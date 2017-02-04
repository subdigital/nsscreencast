//
//  ExtensionDelegate.swift
//  BeerButton WatchKit Extension
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import ClockKit
import UserNotifications
import WatchConnectivity
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    var watchConnectivityBackgroundTasks: [WKWatchConnectivityRefreshBackgroundTask] = []

    override init() {
        super.init()
        
        let session = WCSession.default()

        // https://developer.apple.com/library/content/samplecode/QuickSwitch/Listings/QuickSwitch_WatchKit_Extension_ExtensionDelegate_swift.html
        session.addObserver(self, forKeyPath: "activationState", options: [], context: nil)
        session.addObserver(self, forKeyPath: "hasContentPending", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            self.completeAllTasksIfReady()
        }
    }
    
    func applicationDidFinishLaunching() {
    }

    func applicationDidBecomeActive() {
        setNotificationPreferences()
        returnToDefaultUI()
    }

    func applicationWillResignActive() {
        updateUIForDock()
    }
    
    func applicationDidEnterBackground() {
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: Date(), userInfo: nil) { (_) in
            
        }
    }
    
    /// MARK - Background Refresh Methods
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let watchConnectivityBackgroundTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                handleWatchConnectivityBackgroundTask(watchConnectivityBackgroundTask)
            } else if let snapshotTask = task as? WKSnapshotRefreshBackgroundTask {
                handleSnapshotTask(snapshotTask)
            } else {
                handleRefreshTask(task)
            }
        }
        
        completeAllTasksIfReady()
    }
    
    func completeAllTasksIfReady() {
        let session = WCSession.default()
        // the session's properties only have valid values if the session is activated, so check that first
        if session.activationState == .activated && !session.hasContentPending {
            watchConnectivityBackgroundTasks.forEach { $0.setTaskCompleted() }
            watchConnectivityBackgroundTasks.removeAll()
        }
    }
    
    /// MARK - Notification Methods
    
    func setNotificationPreferences() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let category = UNNotificationCategory(identifier: "BeerButtonOrderDelivery", actions: [], intentIdentifiers: [], options: [])
                center.setNotificationCategories(Set([category]))
            } else {
                print("No Permissions" + error.debugDescription)
            }
        }
    }
    
    /// MARK - UNUserNotificationCenterDelegate Methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .sound])
    }
}

extension ExtensionDelegate {
    /// MARK - Background Update Methods
    
    func handleWatchConnectivityBackgroundTask (_ watchConnectivityBackgroundTask : WKWatchConnectivityRefreshBackgroundTask) {
        self.watchConnectivityBackgroundTasks.append(watchConnectivityBackgroundTask)
    }
    
    func handleSnapshotTask(_ snapshotTask : WKSnapshotRefreshBackgroundTask) {
        if let order = Order.currentOrder() {
            updateSnapshot(status: .Ordered(order, snapshot: true))
            snapshotTask.setTaskCompleted(restoredDefaultState: false, estimatedSnapshotExpiration: order.date, userInfo: nil)
        } else {
            updateSnapshot(status: .None)
            snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
        }
    }
    
    func handleRefreshTask(_ task : WKRefreshBackgroundTask) {
        // Handle our refresh by reloading our complication timeline
        let complicationServer = CLKComplicationServer.sharedInstance()
        
        for complication in complicationServer.activeComplications! {
            complicationServer.reloadTimeline(for: complication)
        }
        
        task.setTaskCompleted()
    }
    
    /// MARK - Internal Methods
    
    func updateUIForDock() {
        if let order = Order.currentOrder() {
            updateSnapshot(status: .Ordered(order, snapshot: true))
        } else {
            updateSnapshot(status: .None)
        }
    }
    
    func returnToDefaultUI() {
        if let interfaceController = WKExtension.shared().rootInterfaceController as? InterfaceController {
            interfaceController.animate(withDuration: 0.5, animations: {
                if let order = Order.currentOrder() {
                    self.updateSnapshot(status: .Ordered(order, snapshot: false))
                } else {
                    self.updateSnapshot(status: .None)
                }
            })
        }
    }
    
    func updateSnapshot(status: OrderStatus) {
        if let interfaceController = WKExtension.shared().rootInterfaceController as? InterfaceController {
            interfaceController.configureUI(status: status)
        }
    }
    
    func scheduleBackgroundRefresh() {
        // Initiate a background refresh for 5 minutes from now.
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 60 * 5), userInfo: nil) { (error) in
            
        }
    }
}
