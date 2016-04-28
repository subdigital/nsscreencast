//
//  EpisodeModel.swift
//  
//
//  Created by NSScreencast on 4/25/16.
//
//

import Foundation
import CoreData

@objc(EpisodeModel)
class EpisodeModel: NSManagedObject {

    class var entityName: String {
        return "Episode"
    }
    
    class func createInContext(context: NSManagedObjectContext) -> EpisodeModel {
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        return EpisodeModel(entity: entity, insertIntoManagedObjectContext: context)
    }

    var publishedAtDate: NSDate {
        return NSDate(timeIntervalSince1970: publishedAtTimeInterval)
    }
    
    var episodeType: EpisodeType {
        return EpisodeType(rawValue: episodeTypeValue)!
    }
}
