//
//  ParseHints.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/26/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class ParseHints {
    var endian: ByteOrder
    var first_parser: (NSData, ParseHints) -> Header
    
    init(endian: ByteOrder, first_parser: (NSData, ParseHints) -> Header) {
        self.endian = endian
        self.first_parser = first_parser
    }
}
