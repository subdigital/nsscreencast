//
//  FetchRemoteEpisodesOperation.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation

class FetchRemoteEpisodesOperation : Operation {
    var path: String
    var error: NSError?
    var task: NSURLSessionDownloadTask?
    
    lazy var session: NSURLSession = {
        return NSURLSession.sharedSession()
    }()
    
    var episodesApiURL: NSURL {
        return NSURL(string: "https://www.nsscreencast.com/api/episodes.json")!
    }
    
    init(path: String) {
        self.path = path
    }
    
    override func execute() {
        task = session.downloadTaskWithURL(episodesApiURL) {
            (url, response, error) in
            
            if error == nil {
                let http = response as! NSHTTPURLResponse
                if http.statusCode != 200 {
                    println("Received HTTP \(http.statusCode)")
                    self.error = NSError(domain: "OperationScreencastErrorDomain", code: 0, userInfo: ["response": http])
                } else {
                    var moveError: NSError?
                    let destinationURL = NSURL(fileURLWithPath: self.path)!
                    if NSFileManager.defaultManager().moveItemAtURL(url, toURL: destinationURL, error: &moveError) {
                        let attributes = NSFileManager.defaultManager().attributesOfItemAtPath(self.path, error: nil)!
                        let bytes = (attributes[NSFileSize] as! NSNumber).longLongValue
                        let formattedSize = NSByteCountFormatter.stringFromByteCount(bytes, countStyle: .File)
                        println("Downloaded \(formattedSize)")
                    } else {
                        println("Error moving file: \(moveError!)")
                        self.error = moveError!
                    }
                }
            } else {
                self.error = error!
            }
            
            self.finish()
        }
        task!.resume()
    }
}
