//
//  Packet.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/13/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

extension NSData {
    func u8(offset: Int) -> UInt8 {
        if offset < length {
            return UnsafePointer<UInt8>(bytes + offset).memory
        } else {
            return 0
        }
    }
    
    func u32(offset: Int) -> UInt32 {
        if offset + 3 < length {
            return UnsafePointer<UInt32>(bytes + offset).memory
        } else {
            return 0
        }
    }

    func u32le(offset: Int) -> UInt32 {
        var n = UInt32(self.u8(offset + 0))
        n += UInt32(self.u8(offset + 1)) * 0x100
        n += UInt32(self.u8(offset + 2)) * 0x10000
        n += UInt32(self.u8(offset + 3)) * 0x1000000
        return n
    }
}

class Packet {
    let data: NSData
    
    // struct pcap_pkthdr
    var timestamp: NSDate
    var captured_length: Int
    var packet_length: Int

    var headers: [Header]

    init(pointer: UnsafePointer<()>, length: Int, hint: ParseHints) {
        if length < 16 {
            // XXX: length error
        }
        
        // XXX: header should be parsed by caller(Pcap)...?
        //      because endian of packet header is dependent on Pcap file
       
        let hdr = NSData(bytes: pointer, length: 16)

        let tv_sec = hdr.u32le(0)
        let tv_usec = hdr.u32le(4)
        let sec = Double(tv_sec) + 1.0e-8 * Double(tv_usec)
        timestamp = NSDate(timeIntervalSince1970: sec)
        captured_length = Int(hdr.u32le(8))
        packet_length = Int(hdr.u32le(12))
        
        // captured_length <= length + ? ...?

        self.data = NSData(bytes: pointer, length: length)

        headers = []

        var ptr  = 0
        var last = captured_length
        var parser = hint.first_parser
        while ptr < last {
            let pdu = parser(data.subdataWithRange(NSRange(ptr...last)), hint)
            if pdu.length == 0 {
                /* XXX */
            }
            if let p = pdu.next_parser {
                parser = p
            } else {
                break
            }
            ptr += pdu.length
        }
    }
}
