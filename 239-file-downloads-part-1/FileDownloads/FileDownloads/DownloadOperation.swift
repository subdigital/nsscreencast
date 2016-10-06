//
//  DownloadOperation.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation

class DownloadOperation : BaseOperation, URLSessionDownloadDelegate {
    
    let url: URL
    let episodeID: Int
    
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
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    override func cancel() {
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
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .downloadProgress,
                                            object: self,
                                            userInfo: userInfo)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Did complete.  error? \(error)")
        finish()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File downloaded to: \(location)")
    }
}
