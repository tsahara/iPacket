//
//  Packet.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/13/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class Packet {
    let data: NSData
    
    // struct pcap_pkthdr
    var timestamp: NSDate
    var captured_length: Int
    var packet_length: Int

    var headers: [Header]
    var src: String?
    var dst: String?

    init(timestamp: NSDate, caplen: Int, pktlen: Int, data: NSData, hint: ParseHints) {
        self.timestamp = timestamp
        self.captured_length = caplen
        self.packet_length = pktlen

        self.data = data
        self.headers = []

        var ptr  = 0
        var last = captured_length
        var parser = hint.first_parser
        while ptr < last {
            let pdu = parser(data.subdataWithRange(NSRange(ptr...last)), hint)
            //println("length=\(length), ptr=\(ptr), last=\(last), pdu.length=\(pdu.length)")
            if pdu.length == 0 {
                /* XXX */
            }
            headers.append(pdu)
            
            if let p = pdu.next_parser {
                parser = p
            } else {
                break
            }
            ptr += pdu.length
        }
        
        self.src = hint.src
        self.dst = hint.dst
    }
    

    var proto: Header {
    get {
        if self.headers.count == 0 {
            return DummyHeader(type: .Unknown)
        } else {
            return self.headers[self.headers.count - 1]
        }
    }
    }
}
