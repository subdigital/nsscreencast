//
//  CoreDataTestCase.swift
//  nsscreencast-tvdemo
//
//  Created by NSScreencast on 4/25/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import XCTest
import CoreData

class CoreDataTestCase: XCTestCase {
    
    func setupInMemoryStore() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch {
            XCTFail()
        }
        
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
    
}
