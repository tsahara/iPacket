//
//  PDU.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

protocol Header {
    class func parser(bytes: NSData, hint: ParseHints) -> Header
    //var offset: Int { get }
    var length: Int { get }
    var fields: [Field] { get }
    var next_parser: ((bytes: NSData, hint: ParseHints) -> Header)? { get }
}

class HeaderImpl: Header {
    var length: Int = 1
    var fields: [Field] = []
    var next_parser: ((bytes: NSData, hint: ParseHints) -> Header)? = nil
    
    class func parser(bytes: NSData, hint: ParseHints) -> Header {
        /* dummy */
        return HeaderImpl()
    }
}
