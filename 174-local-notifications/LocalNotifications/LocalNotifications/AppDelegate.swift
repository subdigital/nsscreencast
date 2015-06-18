//
//  AppDelegate.swift
//  LocalNotifications
//
//  Created by Ben Scheirman on 6/15/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        registerForNotifications(application)
        
        return true
    }
    
    func registerForNotifications(application: UIApplication) {
        
        let action = UIMutableUserNotificationAction()
        action.title = "Mine Again"
        action.identifier = Notifications.Actions.MineAgain.rawValue
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = Notifications.Categories.JobCompleted.rawValue
        category.setActions([action], forContext: .Default)
        category.setActions([action], forContext: .Minimal)
        
        let categories = NSSet(object: category) as! Set<UIUserNotificationCategory>
        
        let settings = UIUserNotificationSettings(
            forTypes:.Alert | .Badge | .Sound,
            categories: categories)
        application.registerUserNotificationSettings(settings)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("Received Local Notification: \(notification)")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if identifier == Notifications.Actions.MineAgain.rawValue {
            NSNotificationCenter.defaultCenter().postNotificationName("MineNotification",
                object: notification,
                userInfo: notification.userInfo)
        }
        
        completionHandler()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

