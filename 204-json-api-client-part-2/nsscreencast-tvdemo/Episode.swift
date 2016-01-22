//
//  Episode.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/10/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

class Episode {
    var episodeId: Int?
    var title: String?
    var number: Int?
    var duration: Int?
    var dominantColor: String?
    var largeImageUrl: NSURL?
    var mediumImageUrl: NSURL?
    var thumbnailImageUrl: NSURL?
    var videoUrl: NSURL?
    var hlsUrl: NSURL?
    var episodeDescription: String?
    var episodeType: EpisodeType?
    var publishedAt: NSDate?
    var showNotes: String?
}