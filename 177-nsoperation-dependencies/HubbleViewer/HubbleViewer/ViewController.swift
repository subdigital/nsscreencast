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
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! 
        let targetPath = NSURL(fileURLWithPath: docsDir).URLByAppendingPathComponent("hubble.jpg").path!

        let downloadOperation = DownloadImageOperation(imageURL: url, targetPath: targetPath)
        
        downloadOperation.progressBlock = { self.downloadProgressView.progress = $0 }
        
        let size = CGSize(width: imageView.bounds.size.width * 2, height: imageView.bounds.size.height * 2)
        let resizeOperation = ResizeImageOperation(path: targetPath, containingSize: size)
        resizeOperation.addDependency(downloadOperation)
        
        let filterOperation = FilterImageOperation(path: targetPath)
        filterOperation.addDependency(resizeOperation)
        
        filterOperation.completionBlock = { [weak filterOperation] in
            if let outputImage = filterOperation?.outputImage {
                let context = CIContext(options: [:])
                let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
                let image = UIImage(CGImage: cgImage)
                self.displayImage(image)
            }
        }
        
        operationQueue.suspended = true
        operationQueue.addOperation(downloadOperation)
        operationQueue.addOperation(resizeOperation)
        operationQueue.addOperation(filterOperation)
        
        operationQueue.suspended = false
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

