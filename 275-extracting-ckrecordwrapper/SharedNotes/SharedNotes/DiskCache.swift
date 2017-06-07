//
//  DiskCache.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

class DiskCache {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var hashedName: String {
        return name.lowercased()
    }
    
    var appCacheDirectory: URL {
        let searchPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return URL(fileURLWithPath: searchPath.first!)
    }
    
    var cacheFilename: String {
       return hashedName.appending(".cache")
    }
    
    var cachesSubfolder: URL {
        return appCacheDirectory.appendingPathComponent("caches")
    }
    
    var cacheLocation: URL {
        return cachesSubfolder.appendingPathComponent(cacheFilename)
    }
    
    func save(object: Any) {
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: cachesSubfolder.path, isDirectory: &isDir) {
            if isDir.boolValue == false {
                try? FileManager.default.removeItem(at: cachesSubfolder)
            }
        } else {
            // doesn't exist
            try? FileManager.default.createDirectory(at: cachesSubfolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        let result = NSKeyedArchiver.archiveRootObject(object, toFile: cacheLocation.path)
        if !result {
            fatalError()
        }
    }
    
    func fetch<T>() -> T? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: cacheLocation.path) as? T
    }
}
