//
//  Episode.swift
//  CoreData10
//
//  Created by Ben Scheirman on 10/3/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Episode)
class Episode : NSManagedObject {
    var thumbnailURL: URL? {
        return thumbnailURLValue.flatMap { return URL(string: $0) }
    }
}
