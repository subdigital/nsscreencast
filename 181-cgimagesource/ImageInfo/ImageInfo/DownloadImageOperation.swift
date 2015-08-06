//
//  DownloadImageOperation.swift
//  ImageInfo
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
            // NSFileManager.defaultManager().removeItemAtPath(targetPath, error: nil)
            println("File already exists at \(targetPath)")
            finish()
            return
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
        
            
            let targetURL = NSURL(fileURLWithPath: targetPath)!
            var copyError : NSError?
            if NSFileManager.defaultManager().copyItemAtURL(location, toURL: targetURL,
                error: &copyError) {
                    finish()
                    
            } else {
                fatalError("Could not copy: \(copyError)")
            }
            
    }
}
