//
//  Document.swift
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/4/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Cocoa

class PcapDocument: NSDocument {
    var pcap: Pcap? = nil
    var bpf: BPF? = nil
    var window: PcapWindowController? = nil

    override init() {
        super.init()
        // Add your subclass-specific initialization here.

        // Document is created by "File > Open"
        println("doc init")
    }

    init(type typeName: String!, error outError: NSErrorPointer) {
        super.init()
        
        // Document is created by "File > New"
        println("doc init type")
        self.pcap = Pcap(byteorder: .LittleEndian)
        self.bpf = BPF(pcap: self.pcap!, document: self)
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)

        // Add any code here that needs to be executed once the windowController has loaded the document's window.
                                    
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }
    
    override class func canConcurrentlyReadDocumentsOfType(typeName: String!) -> Bool {
        println("canConcurrentlyReadDocumentsOfType:", typeName)
        return true
    }


//    override var windowNibName: String {
//        // Returns the nib file name of the document
//        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
//        return "PcapDocument"
//    }
    
    override func makeWindowControllers() {
        self.window = PcapWindowController(windowNibName: "PcapDocument")
        self.addWindowController(self.window)
    }

    override func dataOfType(typeName: String?, error outError: NSErrorPointer) -> NSData? {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//        outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        
        if let pcap = self.pcap {
            return pcap.toData()
        } else {
            return NSData()
        }
    }

    override func readFromData(data: NSData?, ofType typeName: String?, error outError: NSErrorPointer) -> Bool {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
        pcap = Pcap.parse(data!, error: outError)
        if pcap != nil {
            return true
        } else {
            return false
        }
    }
    
    func add_packet(pkt: Packet) {
        if (window != nil) {
            window?.add_packet(pkt)
        }
    }
}

