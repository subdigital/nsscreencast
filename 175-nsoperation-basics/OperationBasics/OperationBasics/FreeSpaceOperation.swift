//
//  FreeSpaceOperation.swift
//  OperationBasics
//
//  Created by Ben Scheirman on 6/25/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation

class FreeSpaceOperation : NSOperation {
    var fileSystemAttributes: NSDictionary?
    var error: NSError?
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    override func main() {
        let fileManager = NSFileManager.defaultManager()
        
        for i in reverse(1...5) {
            if cancelled {
                return
            }

            println("Sleeping \(i)...")
            sleep(1)
        }
        
        if cancelled {
            return
        }
        
        let attribs = fileManager.attributesOfFileSystemForPath(path, error: &error)
        println("attribs for \(path): \(attribs)")
        
        self.fileSystemAttributes = attribs
    }
}
