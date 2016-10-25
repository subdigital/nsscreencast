//
//  PersistenceManager.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/18/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

struct PersistenceManager {
    static var sharedContainer: NSPersistentContainer!
    
    static func save(context: NSManagedObjectContext) throws {
        var ctx: NSManagedObjectContext? = context
        while ctx != nil {
            try ctx?.save()
            ctx = ctx?.parent
        }
    }
}
