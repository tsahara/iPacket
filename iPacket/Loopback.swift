//
//  Loopback.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/15/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class LoopbackPseudoHeader: PDU {
    let af: Int
    
    init(af: Int) {
        self.af = af
    }
}