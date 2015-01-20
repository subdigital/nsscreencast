//
//  WindowController.swift
//  Toggle
//
//  Created by Ben Scheirman on 1/20/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    dynamic var featureAEnabled: Bool {
        return Bool(FeatureAEnabled);
    }
    
}
