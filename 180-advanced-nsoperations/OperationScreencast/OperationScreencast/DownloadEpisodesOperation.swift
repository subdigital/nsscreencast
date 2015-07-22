//
//  DownloadEpisodesOperation.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreData

class DownloadEpisodesOperation : Operation {
    var path: String
    var error: NSError?
    let context: NSManagedObjectContext
    
    private var internalQueue = NSOperationQueue()
    
    init(path: String, context: NSManagedObjectContext) {
        self.path = path
        self.context = context
    }
    
    override func execute() {
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
        }
        
        internalQueue.suspended = true
        
        let fetchOperation = FetchRemoteEpisodesOperation(path: path)
        let importOperation = ImportEpisodesOperation(path: path, context: context)
        importOperation.addDependency(fetchOperation)
        
        internalQueue.addOperation(fetchOperation)
        internalQueue.addOperation(importOperation)
        
        let finalOperation = NSBlockOperation(block: {
            self.finish()
        })
        
        finalOperation.addDependency(importOperation)
        internalQueue.addOperation(finalOperation)
        
        internalQueue.suspended = false
    }
}