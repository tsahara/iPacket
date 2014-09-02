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
        println(self.document)
        return 1
    }
    
//    func tableView(tableView: NSTableView!,
//        viewForTableColumn tableColumn: NSTableColumn!,
//        row: Int) -> NSView! {
//            //let v: AnyObject! = tableView.makeViewWithIdentifier("fuga", owner: self)
//            let t = NSTextField()
//            t.stringValue = "abc"
//            t.textColor = NSColor.blueColor()
//            return t
//    }

    func tableView(tableView: NSTableView!,
        viewForTableColumn tableColumn: NSTableColumn!,
        row: Int) -> NSView! {
            if let result = tableView.makeViewWithIdentifier("PcapView", owner:self) as? NSTextField {
                println("result is \(result)")
                result.stringValue = "abc"
                return result
            } else {
                let t = NSTextField()
                t.stringValue = "abc"
                t.textColor = NSColor.blueColor()
                return t
            }
    }
}
