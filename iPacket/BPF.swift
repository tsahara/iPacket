//
//  BPF.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/16/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class BPF {
    init() {
        let fh = NSFileHandle(forReadingAtPath: "/dev/bpf3")
        let bpf = fh.fileDescriptor
        let r = bpf_setup(bpf, "en0")
        println("bpf_setup =>", r)

        //println(fh.availableData)
        

//        fh.readabilityHandler = {
//            f in println("reader")
//            var buf = [UInt8](count: 2000, repeatedValue: 0)
//            println(read(bpf, &buf, 2000))
//            println(buf)
//        }
//        fh.readabilityHandler = { h in println("read=>\(h.availableData)") }
    }
}