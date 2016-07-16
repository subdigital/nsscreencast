//
//  EpisodeModelTests.swift
//  nsscreencast-tvdemo
//
//  Created by NSScreencast on 4/25/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import XCTest
import CoreData
@testable import nsscreencast_tvdemo

class EpisodeModelTests : CoreDataTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        self.context = setupInMemoryStore()
    }
    
    func testCanSaveEpisode() {
        let episode = EpisodeModel.createInContext(context)
        episode.title = "test episode"
        episode.duration = 15
        
        do {
            try context.save()
        } catch {
            XCTFail()
        }
    }
    
    func testCanFetchEpisodes() {
        let addEpisode: (NSManagedObjectContext, Int16, String) -> EpisodeModel = {
            context, episodeId, title in
            
            let episode = EpisodeModel.createInContext(context)
            episode.title = title
            episode.episodeNumber = episodeId
            return episode
        }
        
        addEpisode(context, 1, "first episode")
        addEpisode(context, 2, "second episode")
        addEpisode(context, 3, "third episode")
        
        do {
            try context.save()
        } catch {
            XCTFail()
        }
        
        let fetchRequest = NSFetchRequest(entityName: EpisodeModel.entityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "episodeNumber", ascending: false)
        ]
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            XCTAssertEqual(3, results.count)
            
            if let episode = results.first as? EpisodeModel {
                XCTAssertEqual(3, episode.episodeNumber)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
}