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

//extension NSData {
//    func getUInt16(offset: Int) -> UInt16 {
//        if offset + 2 < self.length {
//            let p = UnsafePointer<UInt8>(self.bytes) + offset
//            return UInt16(p[0]) << 8 + UInt16(p[1])
//        } else {
//            return 0
//        }
//    }
//
//    func getUInt32(offset: Int) -> UInt32 {
//        if offset + 4 < self.length {
//            let p = UnsafePointer<UInt8>(self.bytes) + offset
//            return UInt32(p[0]) << 24 + UInt32(p[1]) << 16 + UInt32(p[2]) << 8 + UInt32(p[3])
//        } else {
//            return 0
//        }
//    }
//}

let PCAPMAGIC: UInt32 = 0xa1b2c3d4

class Pcap {
    let data: NSData
    let byteorder: ByteOrder
    var packets: [Packet] = []
    
    init(data: NSData, magic: UInt32) {
        if magic == PCAPMAGIC {
            self.byteorder = .BigEndian
        } else {
            self.byteorder = .LittleEndian
        }
        self.data = data
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

        let pcap = Pcap(data: data, magic: data.u32(0))
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
}
