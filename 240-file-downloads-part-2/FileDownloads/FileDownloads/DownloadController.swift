//
//  DownloadController.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

class DownloadController {
    let downloadQueue: OperationQueue
    
    static let shared = DownloadController()
    
    private init() {
        downloadQueue = OperationQueue()
        downloadQueue.maxConcurrentOperationCount = 1
    }
    
    func download(episode: Episode) {
        guard let videoURL = episode.videoURL else { return }
        
        let context = PersistenceManager.sharedContainer.viewContext
        let downloadInfo = DownloadInfo(context: context)
        downloadInfo.downloadedAt = NSDate()
        downloadInfo.status = .Pending
        downloadInfo.episode = episode
        downloadInfo.progress = 0
        try! context.save()
        
        let operation = DownloadOperation(url: videoURL, episodeID: Int(episode.id))
        downloadQueue.addOperation(operation)
    }
}
