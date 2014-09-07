//
//  IPv6.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/27/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

// version:4
// traffic-class:8
// Flow Label: 20
// Payload Length: 16
// Next Header: 8
// Hop Limit: 8
// Source Address: 128
// Destination Address: 128

class IPv6: HeaderImpl {
    var nexthdr: Int = -1
    var src: IPv6Address?
    var dst: IPv6Address?

    required init(length: Int) {
        super.init(type: .IPv6)
        self.length = length
    }
    
    override class func parse(bytes: NSData, hint: ParseHints) -> Header {
        let h = self(length: 40)
        
        h.nexthdr = Int(bytes.u8(6))
        h.src = IPv6Address(fromNSData: bytes.subdataWithRange(NSRange(8..<24)))
        h.dst = IPv6Address(fromNSData: bytes.subdataWithRange(NSRange(24..<40)))

        switch h.nexthdr {
        case 58:
            h.next_parser = ICMP6.parse
        default:
            h.next_parser = nil
        }
        hint.src = h.src!.description()
        hint.dst = h.dst!.description()
        
        return h
    }
}
