//
//  AppDelegate.swift
//  HandoffMac
//
//  Created by Ben Scheirman on 10/6/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
    }
    
    func application(application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print("willContinueUserActivityWithType: \(userActivityType)")
        return true
    }
    
    func application(application: NSApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
        print("didFailToContinueUserActivity: \(error)")
    }
    
    func application(application: NSApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]) -> Void) -> Bool {
        print("Continue activity: \(userActivity.userInfo)")
        return true
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
}

