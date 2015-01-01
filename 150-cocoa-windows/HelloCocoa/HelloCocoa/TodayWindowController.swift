//
//  TodayWindowController.swift
//  HelloCocoa
//
//  Created by Ben Scheirman on 12/31/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import Cocoa

class TodayWindowController: NSWindowController {
    
    class var windowNibName: String {
        return "TodayWindowController"
    }
    
    class func windowController() -> TodayWindowController {
        return TodayWindowController(windowNibName: windowNibName)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
