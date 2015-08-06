//
//  ImageStatsOperation.swift
//  ImageInfo
//
//  Created by Ben Scheirman on 8/3/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import ImageIO

class ImageStatsOperation: Operation {
    let path: String
    
    var imageProperties: NSDictionary?
    
    init(path: String) {
        self.path = path
    }
    
    override func execute() {
        let fileURL = NSURL(fileURLWithPath: path)
        if let imageSource = CGImageSourceCreateWithURL(fileURL, nil) {
            let options = [
                (kCGImageSourceShouldCache as! String): kCFBooleanFalse
            ]
            if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options) {
                println("Image properties: \(properties)")
                self.imageProperties = properties
                finish()
            } else {
                println("Couldn't copy image properties")
                cancel()
            }
            
        } else {
            println("Could not load image source")
            cancel()
        }
    }
}
