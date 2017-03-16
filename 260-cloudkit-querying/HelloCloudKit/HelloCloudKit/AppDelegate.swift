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
                // self.insertFirstRestaurant(container: container)
                self.queryForRestaurants(container: container)
                
                
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
    
    func queryForRestaurants(container: CKContainer) {
        
        // query for a record by ID
//        let recordID = CKRecordID(recordName: "my-restaurant222")
//        container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
//            if let r = record {
//                print("restaurant: \(r["name"])")
//            }
//            
//            if let e = error {
//                print("ERROR: \(e)")
//            }
//        }

        // query for ALL records
        // let predicate = NSPredicate(value: true)  // TRUE Predicate.. returns all records
        
        // query by full text search
        // let predicate = NSPredicate(format: "allTokens TOKENMATCHES[cdl] %@", "grill")
        
        // querying by location
        let location = CLLocation(latitude: 29.8213159, longitude: -95.4244451)
        let radiusInMeters: CGFloat = 4000
        let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(location, %@) < %f", location, radiusInMeters)
        
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 10
        
        var results: [String] = []
        queryOperation.recordFetchedBlock = { record in
            results.append(record["name"] as! String)
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            if let e = error {
                print("Error executing query: \(e)")
            } else {
                print("Done!  Results: \(results)")
            }
        }
        
        container.publicCloudDatabase.add(queryOperation)
    }
    
    func promptForICloud() {
        print("Prompt for iCloud")
        
        let alert = UIAlertController(title: "iCloud Login Required",
                                      message: "This app uses iCloud to store data about restaurants. Please log in in the Settings app",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func insertFirstRestaurant(container: CKContainer) {
        let db = container.publicCloudDatabase
        
        let recordID = CKRecordID(recordName: "my-restaurant")
        
        let record = CKRecord(recordType: "Restaurant", recordID: recordID)
        
        record["name"] = "Hubcap Grill" as NSString
        record["address"] = "1133 W 19th St, Houston, TX 77008" as NSString
        record["location"] = CLLocation(latitude: 29.8029520, longitude: -95.4194210)
        
        let imageURL = Bundle.main.url(forResource: "hubcap", withExtension: "jpg")!
        record["image"] = CKAsset(fileURL: imageURL)
        
        print("saving...")
        db.save(record) { (record, error) in
            if let r = record {
                print("Saved: \(r)")
            } else {
                print("ERROR: \(error!)")
            }
        }
        
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


}

