//
//  AppDelegate.swift
//  CompanyRoster
//
//  Created by Ben Scheirman on 10/12/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        indexContacts()
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        return true
    }
    
    func indexContacts() {
        CSSearchableIndex.defaultSearchableIndex().deleteAllSearchableItemsWithCompletionHandler(nil)
        
        let contacts = ContactsStore().getContacts()
        let items = contacts.map { c in
            return CSSearchableItem(uniqueIdentifier: c.name,
                domainIdentifier: c.department,
                attributeSet: c.searchableAttributeSet())
        }
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(items) { (error) in
            if error == nil {
                print("Indexed \(contacts.count) contacts.")
            } else {
                print("Error: \(error)")
            }
        }
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let nav = splitViewController.viewControllers.first! as! UINavigationController
        let master = nav.viewControllers.first!
        
        if userActivity.activityType == "com.companyroster.viewcontact" {
            master.restoreUserActivityState(userActivity)
            return true
        } else if userActivity.activityType == CSSearchableItemActionType {
            master.restoreUserActivityState(userActivity)
            return true
        }
        
        return false
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.contact == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

