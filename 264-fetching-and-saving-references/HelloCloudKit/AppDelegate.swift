//
//  AppDelegate.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 1/30/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // create review
        //let container = CKContainer.default()
        //let db = container.publicCloudDatabase
        
        //let review = CKRecord(recordType: "Review")
        //review["comment"] = "This place is so good. Definitely get a fried egg on your burger." as NSString
        //review["stars"] = 5.0 as NSNumber
        //review["author_name"] = "Ben" as NSString
        
        // hubcap grill
        //let hubcap = CKRecordID(recordName: "my-restaurant")
        //review["restaurant"] = CKReference(recordID: hubcap, action: .deleteSelf)
        
        //db.save(review) { (record, error) in
        //    print("Record: \(record)            Error: \(error)")
        //}
        
        setupAppearance()
        checkAccountStatus()
        
        
        NotificationCenter.default.addObserver(forName: .CKAccountChanged,
                                               object: nil,
                                               queue: nil) { [weak self] (note) in
                                                print("Identity changed.")
                                                self?.checkAccountStatus()
        }
        
        return true
    }
    
    func checkAccountStatus() {
        print("Checking account status:")
        let container = CKContainer.default()
        container.accountStatus { (accountStatus, error) in
            
            print("Account status: \(accountStatus.rawValue)")
            
            switch accountStatus {
            case .available:
                break
                
            case .noAccount:
                self.promptForICloud()
                
            case .couldNotDetermine:
                if let e = error {
                    print("Error checking account status: \(e)")
                }
                
            case .restricted:
                print("restricted")
            }
        }
    }
    
    func promptForICloud() {
        print("Prompt for iCloud")
        
        let alert = UIAlertController(title: "iCloud Login Required",
                                      message: "This app uses iCloud to store data about restaurants. Please log in in the Settings app",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    private func setupAppearance() {
        window?.tintColor = #colorLiteral(red: 0.5226279145, green: 0.02596991433, blue: 0, alpha: 1)
        
        let navbar = UINavigationBar.appearance()
        navbar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(red:0.46, green:0.38, blue:0.22, alpha:1.00)
        ]
    }
}

