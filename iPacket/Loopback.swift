//
//  Loopback.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

final class LoopbackProtocol: HeaderImpl {
    init(length: Int) {
        super.init()
        self.length = length
    }
    
    class func parse(bytes: NSData, hint: ParseHints) -> Header {
        var af: Int
        let h = LoopbackProtocol(length: 4)

        switch hint.endian {
        case .BigEndian:
            af = Int(bytes.u32(0))
        case .LittleEndian:
            af = Int(bytes.u32le(0))
        }
        h.next_parser = IPv6.parse
        return h
    }
}
