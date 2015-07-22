//
//  LoadDataModelOperation.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreData

class LoadDataModelOperation : Operation {
    let loadHandler: NSManagedObjectContext -> Void
    var context: NSManagedObjectContext?
    
    init(loadHandler: NSManagedObjectContext -> Void) {
        self.loadHandler = loadHandler
        super.init()
    }
    
    var cachesFolder: NSURL {
        return NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
    }
    
    var storeURL: NSURL {
        return cachesFolder.URLByAppendingPathComponent("episodes.sqlite")
    }
    
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModelFromBundles(nil)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.model)
    }()
    
    override func execute() {
        var storeError: NSError?
        if let store = persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &storeError) {
            
        } else {
            println("Couldn't create store")
            abort()
        }
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            self.context!.persistentStoreCoordinator = self.persistentStoreCoordinator
            
            self.loadHandler(self.context!)
            self.finish()
        }
    }
}