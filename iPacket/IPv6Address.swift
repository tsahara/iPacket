//
//  IPv6Address.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class IPv6Address: Field {
    var data: NSData
    
    init(fromNSData data: NSData) {
        self.data = data
    }
    
    func description() -> String {
        var buf = [Int8](count: 48, repeatedValue: 0)
        inet_ntop(AF_INET6, data.bytes, &buf, socklen_t(buf.count))
        return NSString.stringWithCString(buf, encoding: NSASCIIStringEncoding)
    }
}
