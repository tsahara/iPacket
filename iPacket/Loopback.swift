//
//  Loopback.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class LoopbackProtocol: PDU {
    let af: Int

    init(af: Int) {
        self.af = af
    }

    class func parse(data: NSData, hint: ParseHints) -> PDU {
        var af: Int
        switch hint.endian {
        case .BigEndian:
            af = Int(data.u32(0))
        case .LittleEndian:
            af = Int(data.u32le(0))
        }
        return LoopbackProtocol(af: af)
    }
}
