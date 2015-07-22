//
//  Episode.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreData

class Episode: NSManagedObject {

    @NSManaged var serverId: NSNumber
    @NSManaged var title: String
    @NSManaged var artworkUrl: String
    @NSManaged var episodeNumber: NSNumber
    

}
