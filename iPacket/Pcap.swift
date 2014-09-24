//
//  Pcap.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

enum ByteOrder {
    case BigEndian, LittleEndian
}

let PCAPMAGIC: UInt32 = 0xa1b2c3d4

class Pcap {
    let data: NSData? = nil
    let byteorder: ByteOrder
    var packets: [Packet] = []
    
    init(byteorder: ByteOrder) {
        self.byteorder = byteorder
    }

    class func parse(data: NSData, error outError: NSErrorPointer) -> Pcap? {
        var ptr = data.bytes
        var len = data.length
        
        if data.length < 24 {
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("File is too short.",
                    comment: "Read failure reason")])
            return nil
        }
        
        let header = UnsafePointer<pcap_file_header>(ptr).memory
        ptr += 24

        if header.magic != PCAPMAGIC {
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Bad Magic.",
                    comment: "Read failure reason")])
            return nil
        }

        // version major/minor
        // snaplen

        var parser: (NSData, ParseHints) -> Header
        switch Int32(header.linktype) {
        case DLT_NULL:
            parser = LoopbackProtocol.parse
        default:
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unknown Linktype \(header.linktype).",
                    comment: "xxx")])
            return nil
        }
        
        // linktype

        var byteorder: ByteOrder
        if header.magic == PCAPMAGIC {
            byteorder = .BigEndian
        } else {
            byteorder = .LittleEndian
        }

        let pcap = Pcap(byteorder: byteorder)
        let hint = ParseHints(endian: pcap.byteorder, first_parser: parser)

        while len > 16 {
            var pkt = Packet(pointer: ptr, length: len, hint: hint)
            pcap.packets.append(pkt)
            if pkt.captured_length == 0 {
                // XXX: error!
                break
            }
            ptr += pkt.captured_length + 16
            len -= pkt.captured_length - 16
        }
        
        return pcap;
    }
    
    func add_packet(pkt: Packet) {
        packets.append(pkt)
    }
}
