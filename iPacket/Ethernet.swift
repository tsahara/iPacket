//
//  Ethernet.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/22/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

final class EthernetProtocol: HeaderImpl {
    override var name: String { return "Ethernet" }
    
    init(length: Int) {
        super.init(type: .Ethernet)
        self.length = length
    }
    
    override class func parse(bytes: NSData, hint: ParseHints) -> Header {
        let h = EthernetProtocol(length: 14)

        let ethertype = bytes.u16(12)
//        println("ether = ", ethertype, bytes.description)
        
        switch ethertype {
        case 0x86dd:
            h.next_parser = IPv6.parse
        default:
            h.next_parser = nil
        }
        return h
    }
}
