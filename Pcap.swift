//
//  Pcap.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

extension NSData {
    func getUInt16(offset: Int) -> UInt16 {
        if offset + 2 < self.length {
            let p = UnsafePointer<UInt8>(self.bytes) + offset
            return UInt16(p[0]) << 8 + UInt16(p[1])
        } else {
            return 0
        }
    }

    func getUInt32(offset: Int) -> UInt32 {
        if offset + 4 < self.length {
            let p = UnsafePointer<UInt8>(self.bytes) + offset
            return UInt32(p[0]) << 24 + UInt32(p[1]) << 16 + UInt32(p[2]) << 8 + UInt32(p[3])
        } else {
            return 0
        }
    }
}

let PCAPMAGIC: UInt32 = 0xa1b2c3d4

class Pcap {
    let swap_endian: Bool
    
    init(_ header: pcap_file_header) {
        swap_endian = (header.magic == PCAPMAGIC)
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
        println("linktype = \(header.linktype)")

        // version major/minor
        // snaplen
        // linktype

        let pcap = Pcap(header)

        while len > 16 {
            var pkt = Packet(pointer: ptr, length: len)
            
            switch Int32(header.linktype) {
            case DLT_NULL:
                if len < 4 {
                    break
                }
                let af = UnsafePointer<UInt32>(ptr).memory
                pkt.addPDU(LoopbackPseudoHeader(af: Int(af)))
                
            default:
                println("linktype \(header.linktype) is not supported")
                return nil;
            }
            
        }
        
        return pcap;
    }
}
