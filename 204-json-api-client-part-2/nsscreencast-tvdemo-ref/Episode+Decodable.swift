//
//  Episode+Decodable.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/10/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

extension Episode : Decodable {
    typealias DecodedType = Episode
    
    static func decode(json: JSON) -> Decoded<Episode> {
        let episode = Episode()
        episode.episodeId = (json <| "id").value
        episode.title = (json <| "title").value
        episode.number = (json <| "episode_number").value
        episode.episodeType = (json <| "episode_type").value
        
        return .Success(episode)
    }
}