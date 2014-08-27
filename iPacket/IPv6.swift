//
//  IPv6.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/27/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class IPv6: HeaderImpl {
    required init(length: Int) {
        super.init()
        self.length = length
    }
    
    class func parse(bytes: NSData, hint: ParseHints) -> Header {
        let h = self(length: 40)

        switch bytes.u8(6) {
        case 58:
            h.next_parser = ICMP6.parser
        default:
            h.next_parser = nil
        }
        
        return h
    }
}
