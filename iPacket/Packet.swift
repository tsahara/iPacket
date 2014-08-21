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
        if (offset >= length) {
            return 0
        }
        return UnsafePointer<UInt8>(bytes).memory
    }
    
    func u32(offset: Int) -> UInt32 {
        if offset + 4 > length {
            return 0
        }
        
        var val = UInt32(u8(offset))
        val = val * 256 + UInt32(u8(offset+1))
        val = val * 256 + UInt32(u8(offset+2))
        val = val * 256 + UInt32(u8(offset+3))
        return val
    }
}

class Packet {
    let data: NSData
    
    // struct pcap_pkthdr
    var timestamp: NSDate
    var captured_length: UInt32
    var packet_length: UInt32

    var pdu_chain: [PDU]
    
    init(pointer: UnsafePointer<()>, length: Int) {
        self.data = NSData(bytes: pointer, length: length)

        let tv_sec = data.u32(0)
        let tv_usec = data.u32(4)
        let sec = Double(tv_sec) + 1.0e-8 * Double(tv_usec)
        timestamp = NSDate(timeIntervalSince1970: sec)
        captured_length = data.u32(8)
        packet_length = data.u32(12)

        pdu_chain = []
    }
    
    func addPDU(pdu: PDU) {
        pdu_chain.append(pdu)
    }
}
