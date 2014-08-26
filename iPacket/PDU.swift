//
//  PDU.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

protocol PDU {
    class func parse(bytes: NSData, hint: ParseHints) -> PDU
}

class ParseHints {
    var endian: ByteOrder
    var first_parser: (NSData, ParseHints) -> PDU
    
    init(endian: ByteOrder, first_parser: (NSData, ParseHints) -> PDU) {
        self.endian = endian
        self.first_parser = first_parser
    }
}
