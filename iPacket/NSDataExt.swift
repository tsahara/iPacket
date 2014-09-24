//
//  NSDataExt.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/18/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

extension NSData {
    func u8(offset: Int) -> UInt8 {
        if offset < length {
            return UnsafePointer<UInt8>(bytes + offset).memory
        } else {
            return 0
        }
    }

    func u16(offset: Int) -> UInt16 {
        if offset + 1 < length {
            var n = UInt16(self.u8(offset + 0)) * 0x100
            n += UInt16(self.u8(offset + 1))
            return n
        } else {
            return 0
        }
    }

    func u32(offset: Int) -> UInt32 {
        if offset + 3 < length {
            return UnsafePointer<UInt32>(bytes + offset).memory
        } else {
            return 0
        }
    }
    
    func u32le(offset: Int) -> UInt32 {
        var n = UInt32(self.u8(offset + 0))
        n += UInt32(self.u8(offset + 1)) * 0x100
        n += UInt32(self.u8(offset + 2)) * 0x10000
        n += UInt32(self.u8(offset + 3)) * 0x1000000
        return n
    }
}
