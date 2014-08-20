//
//  Packet.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/13/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class Packet {
    let bytes: UnsafePointer<UInt8>
    let bytesize: Int
    
    // struct pcap_pkthdr
    var timestamp: NSDate
    var captured_length: UInt32
    var packet_length: UInt32

    var pdu_chain: [PDU]
    
    init(pointer ptr: UnsafePointer<()>, length len: Int) {
        self.bytes = UnsafePointer<UInt8>(ptr)
        self.bytesize = len
        
        // dummy initializer
        timestamp = NSDate()
        captured_length = 0
        packet_length = 0
        pdu_chain = []
        
        let tv_sec = self.u32(0)
        let tv_usec = self.u32(4)
        let sec = Double(tv_sec) + 1.0e-8 * Double(tv_usec)
        timestamp = NSDate(timeIntervalSince1970: sec)
        captured_length = self.u32(8)
        packet_length = self.u32(12)
    }

    func u32(offset: Int) -> UInt32 {
        if offset + 4 > self.bytesize {
            return 0
        }

        var val: UInt32
        val = UInt32(self.bytes[offset])
        val = val * 256 + UInt32(self.bytes[offset+1])
        val = val * 256 + UInt32(self.bytes[offset+2])
        val = val * 256 + UInt32(self.bytes[offset+3])
        return val
    }
    
    func addPDU(pdu: PDU) {
        pdu_chain.append(pdu)
    }
}
