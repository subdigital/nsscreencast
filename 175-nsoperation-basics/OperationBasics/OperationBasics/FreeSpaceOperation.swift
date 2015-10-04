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
        
        for i in (1...5).reverse() {
            if cancelled {
                return
            }
            
            print("Sleeping \(i)...")
            sleep(1)
        }
        
        if cancelled {
            return
        }

        do {
            let attribs = try fileManager.attributesOfFileSystemForPath(path)
            print("attribs for \(path): \(attribs)")
            
            self.fileSystemAttributes = attribs
        } catch {
            print(error)
        }
    }
}
