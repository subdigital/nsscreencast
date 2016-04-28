//
//  Episode+Decodable.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/11/16.
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
        episode.dominantColor = (json <| "dominant_color").value
        episode.largeImageUrl = (json <| "large_artwork_url").value
        episode.mediumImageUrl = (json <| "medium_artwork_url").value
        episode.thumbnailImageUrl = (json <| "small_artwork_url").value
        episode.videoUrl = (json <| "video_url").value
        episode.hlsUrl = (json <| "hls_url").value
        episode.episodeType = (json <| "episode_type").value
        episode.episodeDescription = (json <| "description").value
        episode.showNotes = (json <| "show_notes").value
        episode.duration = (json <| "duration").value
        episode.publishedAt = (json <| "published_at" >>- DateHelper.parseDateISO8601).value
        
        return .Success(episode)
    }

}