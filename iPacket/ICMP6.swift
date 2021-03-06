//
//  ICMP6.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/27/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class ICMP6: HeaderImpl {
    required init(length: Int) {
        super.init(type: .ICMP6)
        self.length = length
    }
    
    override class func parse(bytes: NSData, hint: ParseHints) -> Header {
        let h = self(length: 8)
        return h
    }
}
