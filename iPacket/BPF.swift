//
//  BPF.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/16/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class BPF {
    var fh: NSFileHandle
    
    init() {
        fh = NSFileHandle(forReadingAtPath: "/dev/bpf3")
        let bpf = fh.fileDescriptor
        let r = bpf_setup(bpf, "en0")
        println("bpf_setup =>", r)

        fh.readabilityHandler = { (fh) in
            var buf = [UInt8](count: 2000, repeatedValue: 0)
            println(read(fh.fileDescriptor, &buf, 2000))
        }
    }
}