//
//  EpisodeResponse.swift
//  CoreData10
//
//  Created by Ben Scheirman on 9/27/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation

struct EpisodeResponse {
    let id: Int
    let title: String
    let summary: String
    let thumbnailURLValue: String

    init?(json: [String : Any]) {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let summary = json["description"] as? String,
            let thumbnailURLValue = json["small_artwork_url"] as? String else {
                print("Could not create episode from json: \(json)")
                return nil
        }

        self.id = id
        self.title = title
        self.summary = summary
        self.thumbnailURLValue = thumbnailURLValue
    }
}
