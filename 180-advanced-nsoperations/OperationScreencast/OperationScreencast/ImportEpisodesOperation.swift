//
//  ImportEpisodesOperation.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreData

struct ParsedEpisode : Printable {
    let serverId: Int
    let episodeNumber: Int
    let title: String
    let artworkUrl: String
    
    init(_ dict: [String: AnyObject]) {
        serverId = dict["id"] as? Int ?? -1
        episodeNumber = dict["episode_number"] as? Int ?? -1
        title = dict["title"] as? String ?? "<untitled>"
        artworkUrl = dict["retina_image_url"] as? String ?? dict["thumbnail_url"] as! String
    }
    
    var description: String {
        return "\(episodeNumber) - \(title)"
    }
}

class ImportEpisodesOperation : Operation {
    var path: String
    var error: NSError?
    
    private var importContext: NSManagedObjectContext
    
    init(path: String, context: NSManagedObjectContext) {
        self.path = path
        importContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        importContext.mergePolicy = NSOverwriteMergePolicy
        importContext.parentContext = context
    }
    
    override func execute() {
        println("Executing import")
        if let episodes = parseEpisodes() {
            importEpisodes(episodes)
        } else {
            println("Couldn't parse episodes")
        }
        
        finish()
    }
    
    func parseEpisodes() -> [ParsedEpisode]? {
        if let inputStream = NSInputStream(fileAtPath: path) {
            inputStream.open()
            var jsonError: NSError?
            if let json = NSJSONSerialization.JSONObjectWithStream(inputStream, options: nil, error: &jsonError) as? [[String: [String: AnyObject]]] {
                inputStream.close()
                
                let episodeDictionaries = json.map { $0["episode"]! }
                let episodes = episodeDictionaries.map { ParsedEpisode($0) }
                println("Parsed \(episodes.count) episodes.")
                return episodes
                
            } else {
                inputStream.close()
                if jsonError != nil {
                    error = jsonError
                } else {
                    println("root json was not an array")
                    abort()
                }
                finish()
                return nil
            }
        } else {
            println("download file did not exist, aborting")
            finish()
            return nil
        }
    }
    
    func importEpisodes(episodes: [ParsedEpisode]) {
        importContext.performBlock {
            let existingEpisodes = self.existingEpisodes()
            for parsed in episodes {
                let episode: Episode
                if let existing = (filter(existingEpisodes) {
                        parsed.serverId == $0.serverId.integerValue
                    }).first {
                    episode = existing
                } else {
                    episode = NSEntityDescription.insertNewObjectForEntityForName("Episode", inManagedObjectContext: self.importContext) as! Episode
                }
                
                episode.serverId = parsed.serverId
                episode.episodeNumber = parsed.episodeNumber
                episode.title = parsed.title
                episode.artworkUrl = parsed.artworkUrl
            }
            
            self.saveContext()
        }
    }
    
    func existingEpisodes() -> Set<Episode> {
        let request = NSFetchRequest(entityName: "Episode")
        let episodes = importContext.executeFetchRequest(request, error: nil)!.map {  $0 as! Episode }
        return Set(episodes)
    }
    
    func saveContext() -> NSError? {
        var saveError: NSError?
        var context: NSManagedObjectContext? = importContext
        
        while context != nil {
            
            if context!.hasChanges {
                if context!.save(&saveError) {
                    println("Saved context: \(context!)")
                } else {
                    break
                }
            }
            
            context = context?.parentContext
        }
        
        return saveError
    }
}