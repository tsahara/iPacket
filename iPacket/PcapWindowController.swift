//
//  PcapWindowController.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/1/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

//import Foundation
import Cocoa

class PcapWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    override init()  {
        println("win init")
        super.init()
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
        println("win init(window): document=\(document)")
    }
    
    required init(coder: NSCoder!) {
        println("win init(coder)")
        super.init(coder: coder)
    }
    
    // NSTableViewDataSource
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        let document = self.document as PcapDocument
        if document.pcap != nil {
            return document.pcap!.packets.count
        } else {
            return 0
        }
    }

    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int) -> NSView! {
            let document = self.document as PcapDocument
            let pkt = document.pcap!.packets[row]
            
            var text: NSTextField
            if let t = tableView.makeViewWithIdentifier("PcapView", owner:self) as? NSTextField {
                text = t
            } else {
                text = NSTextField()
            }
            
            text.editable = false
            text.selectable = false
            text.drawsBackground = false
            text.bezeled = false

//          t.textColor = NSColor.blueColor()
            switch tableColumn.identifier {
            case "time":
                let df = NSDateFormatter()
                df.dateFormat = "HH:mm:ss"

                let nf = NSNumberFormatter()
                nf.format = ".000"

                text.stringValue = df.stringFromDate(pkt.timestamp) + nf.stringFromNumber(pkt.timestamp.timeIntervalSince1970 % 1)
            case "source":
                text.stringValue = pkt.src
            case "destination":
                text.stringValue = pkt.dst
            case "proto":
                text.stringValue = pkt.proto.name
            default:
                text.stringValue = "???"
            }
            return text
    }
}
