//
//  DownloadController.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation

class DownloadController {
    let downloadQueue: OperationQueue
    
    static let shared = DownloadController()
    
    private init() {
        downloadQueue = OperationQueue()
        downloadQueue.maxConcurrentOperationCount = 1
    }
    
    func download(episode: Episode) {
        guard let videoURL = episode.videoURL else { return }
        let operation = DownloadOperation(url: videoURL, episodeID: Int(episode.id))
        downloadQueue.addOperation(operation)
    }
}
