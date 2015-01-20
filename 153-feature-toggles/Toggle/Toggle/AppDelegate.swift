//
//  AppDelegate.swift
//  Toggle
//
//  Created by Ben Scheirman on 1/20/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowController: WindowController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        windowController = WindowController(windowNibName: "WindowController")
        windowController.showWindow(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

