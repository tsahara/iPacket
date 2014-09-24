//
//  Header.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

protocol Header {
    class func parse(bytes: NSData, hint: ParseHints) -> Header
    //var offset: Int { get }
    var length: Int { get }
    var fields: [Field] { get }
    var next_parser: ((bytes: NSData, hint: ParseHints) -> Header)? { get }
    var name: String { get }
    var type: HeaderType { get }
}

class HeaderImpl: Header {
    var type: HeaderType
    var length: Int = 1
    var fields: [Field] = []
    var next_parser: ((bytes: NSData, hint: ParseHints) -> Header)? = nil

    var name: String {
        return type.rawValue
    }

    init(type: HeaderType) {
        self.type = type
    }
    
    class func parse(bytes: NSData, hint: ParseHints) -> Header {
        /* dummy */
        return HeaderImpl(type: .Unknown)
    }
}

class DummyHeader: HeaderImpl {
}

enum HeaderType: String {
    case Ethernet = "ethernet"
    case ICMP6 = "icmp6"
    case IPv6 = "ipv6"
    case Loopback = "loopback"
    case Unknown = "unknown"
}
