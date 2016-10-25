//
//  Episode.swift
//  CoreData10
//
//  Created by Ben Scheirman on 9/27/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Episode)
class Episode : NSManagedObject {
    var thumbnailURL: URL? {
        return thumbnailURLValue.flatMap(URL.init)
    }
    
    var videoURL: URL? {
        return videoURLValue.flatMap(URL.init)
    }
}
