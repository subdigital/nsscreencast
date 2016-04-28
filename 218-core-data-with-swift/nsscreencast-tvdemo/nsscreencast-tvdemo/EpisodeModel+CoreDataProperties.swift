//
//  EpisodeModel+CoreDataProperties.swift
//  
//
//  Created by NSScreencast on 4/25/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EpisodeModel {

    @NSManaged var dominantColor: String
    @NSManaged var duration: Int32
    @NSManaged var episodeDescription: String
    @NSManaged var episodeNumber: Int16
    @NSManaged var episodeTypeValue: String
    @NSManaged var hasHLS: Bool
    @NSManaged var hasWatched: Bool
    @NSManaged var hlsURLValue: String
    @NSManaged var isFavorite: Bool
    @NSManaged var largeArtworkURLValue: String
    @NSManaged var mediumArtworkURLValue: String
    @NSManaged var publishedAtTimeInterval: NSTimeInterval
    @NSManaged var serverId: Int16
    @NSManaged var thumbnailURLValue: String
    @NSManaged var title: String
    @NSManaged var videoURLValue: String

}
