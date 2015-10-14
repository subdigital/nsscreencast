//
//  DownloadImageOperation.swift
//  HubbleViewer
//
//  Created by Ben Scheirman on 7/1/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation

class DownloadImageOperation : Operation, NSURLSessionDownloadDelegate {
    
    let imageURL: NSURL
    let targetPath: String
    
    var downloadTask: NSURLSessionDownloadTask?
    var progressBlock: (Float) -> () = { _ in }
    
    init(imageURL: NSURL, targetPath: String) {
        self.imageURL = imageURL
        self.targetPath = targetPath
    }
    
    lazy var session: NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        return NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    override func execute() {
        if NSFileManager.defaultManager().fileExistsAtPath(targetPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(targetPath)
            } catch _ {
            }
        }
        
        downloadTask = session.downloadTaskWithURL(imageURL)
        downloadTask?.resume()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64) {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            dispatch_async(dispatch_get_main_queue()) {
                self.progressBlock(progress)
            }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL) {
            let targetURL = NSURL(fileURLWithPath: targetPath)
            do {
                try NSFileManager.defaultManager().copyItemAtURL(location, toURL: targetURL)
                finish()
            } catch let copyError as NSError {
                fatalError("Could not copy: \(copyError)")
            }
            
    }
}