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
        let r = bpf_setup(bpf, "en4")
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
            var buflen = read(fh.fileDescriptor, ptr, 2000)
            println("read \(buflen) bytes")
           
            while buflen > sizeof(bpf_hdr) {
                let hdr = UnsafePointer<bpf_hdr>(ptr).memory
                
                if (UInt32(hdr.bh_hdrlen) + hdr.bh_caplen > UInt32(buflen)) {
                    println("BPF hdrlen + caplen > buf???")
                    break
                }

                let sec = Double(hdr.bh_tstamp.tv_sec) + 1.0e-6 * Double(hdr.bh_tstamp.tv_usec)
                let ts  = NSDate(timeIntervalSince1970: sec)
                let p   = ptr + Int(hdr.bh_hdrlen)
                let d   = NSData(bytes: p, length: Int(hdr.bh_caplen))
                
                var pkt = Packet(timestamp: ts,
                    caplen: Int(hdr.bh_caplen),
                    pktlen: Int(hdr.bh_datalen),
                    data: d,
                    hint: hint)

                pcap.add_packet(pkt)
                self.document.add_packet(pkt)

                if pkt.captured_length == 0 {
                    println("caplen=0")
                    break
                }
                ptr += Int(hdr.bh_hdrlen) + pkt.captured_length
                buflen -= Int(hdr.bh_hdrlen) + pkt.captured_length
            }
        }
    }
}
