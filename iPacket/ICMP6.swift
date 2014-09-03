//
//  ICMP6.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/27/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class ICMP6: HeaderImpl {
    override var name: String { return "ICMP6" }

    required init(length: Int) {
        super.init()
        self.length = length
    }
    
    override class func parse(bytes: NSData, hint: ParseHints) -> Header {
        let h = self(length: 8)
        println("icmp5")
        return h
    }
}
