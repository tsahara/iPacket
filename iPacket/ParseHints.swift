//
//  ParseHints.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/26/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class ParseHints {
    var first_parser: (NSData, ParseHints) -> Header
    var endian: ByteOrder
    var from_bpf = false
    var src: String? = nil
    var dst: String? = nil
    var ip:  Header? = nil   // IPv4 or IPv6 Header
    
    init(endian: ByteOrder, first_parser: (NSData, ParseHints) -> Header) {
        self.endian = endian
        self.first_parser = first_parser
    }
}
