//
//  ViewController.swift
//  HubbleViewer
//
//  Created by Ben Scheirman on 6/30/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    
    let operationQueue = NSOperationQueue()
    
    @IBAction func downloadButtonTapped(sender: AnyObject) {
        
        let url = NSURL(string: "http://imgsrc.hubblesite.org/hu/db/images/hs-2006-10-a-hires_jpg.jpg")!
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! as! String
        let targetPath = docsDir.stringByAppendingPathComponent("hubble.jpg")

        
    }
    
    func displayImage(image: UIImage) {
        self.imageView.alpha = 0
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = image
            UIView.animateWithDuration(0.3) {
                self.imageView.alpha = 1
            }
        }
    }
}

