//
//  BPF.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/16/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class BPF {
    var document: PcapDocument
    var pcap: Pcap
    var fh: NSFileHandle
    
    init(pcap: Pcap, document: PcapDocument) {
        fh = NSFileHandle(forReadingAtPath: "/dev/bpf3")!
        let bpf = fh.fileDescriptor
        let r = bpf_setup(bpf, nil)
        println("bpf_setup =>", r)
        if (r != 0) {
            self.document = document
            self.pcap = pcap
            return
        }
        
        // make parsehint since we have bpf here (can determine first_parser)
        let hint = ParseHints(endian: .LittleEndian, first_parser: EthernetProtocol.parse)
        hint.from_bpf = true

        self.pcap = pcap
        self.document = document

        fh.readabilityHandler = { (fh) in
            var buf = [UInt8](count: 2000, repeatedValue: 0)
            var ptr = UnsafeMutablePointer<UInt8>(buf)
            var len = read(fh.fileDescriptor, ptr, 2000)
            println("read \(len) bytes")
            
            while len > 18 {
                let hdr = UnsafePointer<bpf_hdr>(ptr).memory
                println("hdrlen=", hdr.bh_hdrlen)
                
//                var pkt = Packet(pointer: ptr, length: len, hint: hint)
//                pcap.add_packet(pkt)
//                if pkt.captured_length == 0 {
//                    // XXX: error!
//                    println("caplen=0")
//                    break
//                }
//                ptr += pkt.captured_length + 18
//                len -= pkt.captured_length - 18
//                
//                self.document.add_packet(pkt)
                break
            }
        }
    }
}