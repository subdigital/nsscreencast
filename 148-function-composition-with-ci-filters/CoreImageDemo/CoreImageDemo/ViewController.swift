//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Ben Scheirman on 11/22/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

typealias Filter = CIImage ->  CIImage

infix operator • { associativity left }

func •(f1: Filter, f2: Filter) -> Filter {
    return {
        image in
        f2(f1(image))
    }
}

func sepia() -> Filter {
    return {
        image in
        let filter = CIFilter(name: "CISepiaTone", withInputParameters: [
            kCIInputImageKey: image
        ])
        return filter.outputImage
    }
}

func blur(radius: Double) -> Filter {
    return {
        image in
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [
            kCIInputImageKey: image,
            kCIInputRadiusKey: radius
            ])
        return filter.outputImage
    }
}

func vortex(angle: Double) -> Filter {
    return {
        image in
        let filter = CIFilter(name: "CIVortexDistortion", withInputParameters:[
            kCIInputImageKey: image,
            kCIInputAngleKey: angle
        ])
        return filter.outputImage
    }
}

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
            

            let filter = sepia() • blur(4.0) • vortex(200)
            let output = filter(cimg)
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