//
//  DownloadOperation.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

class DownloadOperation : BaseOperation, URLSessionDownloadDelegate {
    
    let url: URL
    let episodeID: Int
    
    lazy var context: NSManagedObjectContext = PersistenceManager.sharedContainer.newBackgroundContext()
    
    lazy var downloadInfo: DownloadInfo! = {
        let fetchRequest: NSFetchRequest<DownloadInfo> = DownloadInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "episode.id = %d", self.episodeID)
        fetchRequest.fetchLimit = 1
        return try! self.context.fetch(fetchRequest).first!
    }()
    
    let sessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = {
        let session = URLSession(configuration: self.sessionConfiguration,
                                 delegate: self,
                                 delegateQueue: nil)
        return session
    }()
    
    var downloadTask: URLSessionDownloadTask?
    
    init(url: URL, episodeID: Int) {
        self.url = url
        self.episodeID = episodeID
    }
    
    override func execute() {
        downloadInfo.status = .Downloading
        try! PersistenceManager.save(context: context)
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    override func cancel() {
        try! PersistenceManager.save(context: context)
        
        downloadTask?.cancel()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        let userInfo: [String: Any] = [
            "episodeID" : episodeID,
            "progress" : progress,
            "totalBytesWritten" : totalBytesWritten,
            "totalBytesExpectedToWrite" : totalBytesExpectedToWrite
        ]
        
        downloadInfo.progress = progress
        downloadInfo.sizeInBytes = totalBytesWritten
        
        // TODO: throttle save
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .downloadProgress,
                                            object: self,
                                            userInfo: userInfo)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Did complete download")
        
        if let e = error as? NSError {
            print("Error: \(e)")
            
            if e.domain == NSURLErrorDomain && e.code == NSURLErrorCancelled {
                downloadInfo.status = .Paused
            } else {
                downloadInfo.status = .Failed
            }
        } else {
            downloadInfo.status = .Completed
        }
        try! PersistenceManager.save(context: context)
        
        finish()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File downloaded to: \(location)")
        
        let ext = downloadTask.currentRequest?.url?.pathExtension ?? "mp4"
        let uuid = UUID()
        let dir = DownloadInfo.offlineLocation
        
        if !FileManager.default.fileExists(atPath: dir.path) {
            try! FileManager.default.createDirectory(at: dir, withIntermediateDirectories: false, attributes: nil)
        }
        
        let filename = "\(uuid.uuidString).\(ext)"
        let targetLocation = dir.appendingPathComponent(filename)
        
        try! FileManager.default.moveItem(at: location, to: targetLocation)
        let attribs = try! FileManager.default.attributesOfItem(atPath: targetLocation.path)
        
        downloadInfo.progress = 1.0
            
        if let sizeNumber = attribs[FileAttributeKey.size] as? NSNumber {
            downloadInfo.sizeInBytes = sizeNumber.int64Value
        }
        
        downloadInfo.path = targetLocation.path
    }
}
