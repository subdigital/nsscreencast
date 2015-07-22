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
        
    }
}