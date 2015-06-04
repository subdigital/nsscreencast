//
//  FKBRemoteImageView.swift
//
//  Created by Ben Scheirman on 4/28/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class FKBRemoteImageView : UIImageView {
    
    static var configuration: NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return config
        }()
    
    static var session: NSURLSession = {
        let session = NSURLSession(
            configuration: FKBRemoteImageView.configuration,
            delegate: nil,
            delegateQueue: nil)
        session.delegateQueue.maxConcurrentOperationCount = 2
        return session
        }()
    
    var imageTask: NSURLSessionDataTask?
    
    func fkb_setImageWithURL(url: NSURL!, placeholder: UIImage? = nil) {
        imageTask?.cancel()
        imageTask = self.dynamicType.session.dataTaskWithURL(url) { (data, response, error) in
            if error == nil {
                if let http = response as? NSHTTPURLResponse {
                    if http.statusCode == 200 {
                        
                        assert(!NSThread.isMainThread(), "called on main thread!")
                        
                        if (self.imageTask!.state == NSURLSessionTaskState.Canceling) {
                            return
                        }
                        
                        self.fkb_loadImageWithData(data)
                    } else {
                        println("received an HTTP \(http.statusCode) downloading \(url)")
                    }
                } else {
                    println("Not an HTTP response")
                }
            } else {
                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) {
                    // ignore this, will happen in normal use
                    return
                }
                println("Error downloading image: \(url) -- \(error)")
            }
        }
        if let placeholderImage = placeholder {
            image = placeholder
        }
        imageTask?.resume()
    }
    
    private func fkb_loadImageWithData(data: NSData) {
        if let image = UIImage(data: data) {
            dispatch_async(dispatch_get_main_queue()) {
                self.image = image
                
                let transition = CATransition()
                transition.duration = 0.25
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                transition.type = kCATransitionFade
                self.layer.addAnimation(transition, forKey: nil)
            }
        }
    }
    
    func fkb_cancelImageLoad() {
        imageTask?.cancel()
    }
}