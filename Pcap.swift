//
//  Pcap.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class Pcap {
    class func parse(data: NSData, error outError: NSErrorPointer) -> Pcap? {
        if data == nil {
            outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
            return nil
        }
        
        //data.bytes
        
        return Pcap()
    }
}