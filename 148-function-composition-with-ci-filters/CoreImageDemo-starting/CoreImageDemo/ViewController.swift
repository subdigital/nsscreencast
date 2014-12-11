//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Ben Scheirman on 11/22/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var originalImage: UIImage!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = imageView.image
    }
    
    @IBAction func tap(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSOperationQueue().addOperationWithBlock {
            var cimg = CIImage(image: self.originalImage)
            let filter = CIFilter(name: "CISepiaTone", withInputParameters: [
                kCIInputImageKey: cimg]
            )
            let sepiaOutput = filter.outputImage
            
            let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: [
                kCIInputImageKey: sepiaOutput,
                kCIInputRadiusKey: 4.0
            ])
            
            let output = blur.outputImage
            let context = CIContext(options: [:])
            let cgimg = context.createCGImage(output, fromRect: output.extent())
            let outputImage = UIImage(CGImage: cgimg)
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.imageView.image = outputImage
            }
        }
    }
}