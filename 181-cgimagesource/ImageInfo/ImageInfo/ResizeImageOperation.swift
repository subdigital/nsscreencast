//
//  ResizeImageOperation.swift
//  ImageInfo
//
//  Created by Ben Scheirman on 7/7/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import ImageIO
import MobileCoreServices

class ResizeImageOperation : Operation {
    let path: String
    let containingSize: CGSize

    var resizedImagePath: String {
        let filename = path.lastPathComponent
        let baseDir = path.stringByDeletingLastPathComponent
        let ext = filename.pathExtension
        let resizedFilename = "\(filename.stringByDeletingPathExtension)-resized.\(ext)"
        return baseDir.stringByAppendingPathComponent(resizedFilename)
    }
    
    init(path: String, containingSize: CGSize) {
        self.path = path
        self.containingSize = containingSize
    }
    
    override func execute() {
        let maxDimension = max(containingSize.width, containingSize.height)
        betterResize(maxDimension)
        finish()
    }
    
    func betterResize(maxDimension: CGFloat) {
        let url = NSURL(fileURLWithPath: path)
        if let imageSource = CGImageSourceCreateWithURL(url, nil) {
            
            let options = [
                kCGImageSourceCreateThumbnailFromImageIfAbsent as String : kCFBooleanTrue,
                kCGImageSourceCreateThumbnailWithTransform as String : kCFBooleanTrue,
                kCGImageSourceThumbnailMaxPixelSize as String : maxDimension
            ] as NSDictionary
            let resized = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
            let targetURL = NSURL(fileURLWithPath: resizedImagePath)
            if let destination =  CGImageDestinationCreateWithURL(targetURL, kUTTypeJPEG, 1, nil) {
                CGImageDestinationAddImage(destination, resized, nil)
                
                if CGImageDestinationFinalize(destination) {
                    println("Resized to \(resizedImagePath)")
                } else {
                    abort()
                }
            } else {
                abort()
            }
        } else {
            abort()
        }
    }
    
    func printSizeOnDisk(data: NSData) {
        let bytes = Int64(data.length)
        let size = NSByteCountFormatter.stringFromByteCount(bytes, countStyle: NSByteCountFormatterCountStyle.File)
        println("Size on disk: \(size)")
    }
}
