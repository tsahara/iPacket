//
//  Pcap.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Foundation

enum ByteOrder {
    case BigEndian, LittleEndian
}

let PCAPMAGIC: UInt32 = 0xa1b2c3d4

class Pcap {
    let data: NSData? = nil
    let byteorder: ByteOrder
    var packets: [Packet] = []
    
    init(byteorder: ByteOrder) {
        self.byteorder = byteorder
    }

    class func parse(data: NSData, error outError: NSErrorPointer) -> Pcap? {
        var ptr = data.bytes
        var len = data.length
        
        if data.length < 24 {
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("File is too short.",
                    comment: "Read failure reason")])
            return nil
        }
        
        let header = UnsafePointer<pcap_file_header>(ptr).memory
        ptr += 24

        if header.magic != PCAPMAGIC {
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Bad Magic.",
                    comment: "Read failure reason")])
            return nil
        }

        // version major/minor
        // snaplen

        var parser: (NSData, ParseHints) -> Header
        switch Int32(header.linktype) {
        case DLT_NULL:
            parser = LoopbackProtocol.parse
        default:
            outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: [
                /* NSLocalizedDescriptionKey: NSLocalizedString("Could not read file 000.", comment: "Read error description"), */
                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unknown Linktype \(header.linktype).",
                    comment: "xxx")])
            return nil
        }
        
        // linktype

        var byteorder: ByteOrder
        if header.magic == PCAPMAGIC {
            byteorder = .BigEndian
        } else {
            byteorder = .LittleEndian
        }

        let pcap = Pcap(byteorder: byteorder)
        let hint = ParseHints(endian: pcap.byteorder, first_parser: parser)

        while len > 16 {
            var pkt = Pcap.parse_a_packet(ptr, length: len, hint: hint)
            pcap.packets.append(pkt)
            if pkt.captured_length == 0 {
                // XXX: error!
                break
            }
            ptr += pkt.captured_length + 16
            len -= pkt.captured_length - 16
        }
        
        return pcap;
    }

    class func parse_a_packet(pointer: UnsafePointer<Void>, length: Int, hint: ParseHints) -> Packet {
        if length < 16 {
            // XXX: length error
            println("Pakcet.init length error")
        }
        
        // XXX: header should be parsed by caller(Pcap)...?
        //      because endian of packet header is dependent on Pcap file
        
        let packet_header = NSData(bytes: pointer, length: 16)
        
        let tv_sec  = packet_header.u32le(0)
        let tv_usec = packet_header.u32le(4)
        let sec = Double(tv_sec) + 1.0e-6 * Double(tv_usec)
        let timestamp = NSDate(timeIntervalSince1970: sec)
        let captured_length = Int(packet_header.u32le(8))
        let packet_length   = Int(packet_header.u32le(12))
        
        // captured_length <= length + ? ...?
        
        var hdrsize: Int
        if (hint.from_bpf) {
            hdrsize = 18
        } else {
            hdrsize = 16
        }
        
        return Packet(timestamp: timestamp, caplen: captured_length, pktlen: packet_length, data: NSData(bytes: pointer + 16, length: length), hint: hint)
    }

    
    func add_packet(pkt: Packet) {
        packets.append(pkt)
    }
    
    func toData() -> NSData {
        var data = NSMutableData()
        
        // write file header
        let maxsnaplen = bpf_u_int32(2000)  // XXX
        var filehdr = pcap_file_header(magic: PCAPMAGIC, version_major: 2,
            version_minor: 4, thiszone: 0, sigfigs: 0, snaplen: maxsnaplen,
            linktype: 0)
        // XXX: linktype
        data.appendBytes(&filehdr, length: sizeof(pcap_file_header))

        // write packets...
        for pkt in packets {
            let sec     = pkt.timestamp.timeIntervalSince1970
            let ts_sec  = UInt32(sec)
            let ts_usec = UInt32((sec - floor(sec)) * 1.0e+6)
            var pkthdr: [UInt32] = [ ts_sec, ts_usec, UInt32(pkt.captured_length), UInt32(pkt.packet_length) ]
            data.appendBytes(&pkthdr, length: 16)
            
            // append packet payload
            data.appendData(pkt.data)
        }
        
        return data
    }
}
