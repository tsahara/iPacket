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
        super.init()
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init(coder: NSCoder!) {
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

    func tableView(tableView: NSTableView!,
        viewForTableColumn tableColumn: NSTableColumn!,
        row: Int) -> NSView! {
            let document = self.document as PcapDocument
            let pkt = document.pcap!.packets[row]
            
            if let result = tableView.makeViewWithIdentifier("PcapView", owner:self) as? NSTextField {
                result.stringValue = "abc"
                return result
            } else {
                let t = NSTextField()
                t.editable = false
                t.selectable = false
                t.drawsBackground = false
                t.bezeled = false
                t.stringValue = "abc"
//                t.textColor = NSColor.blueColor()
                if tableColumn.identifier == "proto" {
                    t.stringValue = pkt.proto.name
                }
                return t
            }
    }
}
