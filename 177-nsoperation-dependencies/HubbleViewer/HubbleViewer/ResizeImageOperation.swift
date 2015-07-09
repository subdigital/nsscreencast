//
//  ResizeImageOperation.swift
//  HubbleViewer
//
//  Created by Ben Scheirman on 7/7/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import UIKit

class ResizeImageOperation : Operation {
    let path: String
    let containingSize: CGSize
    
    init(path: String, containingSize: CGSize) {
        self.path = path
        self.containingSize = containingSize
    }
    
    override func execute() {
        let sourceImage = UIImage(contentsOfFile: path)!
        println("Source image size: \(sourceImage.size)")
        printSizeOnDisk(UIImageJPEGRepresentation(sourceImage, 1.0))
        
        let width: CGFloat
        let height: CGFloat
        let ratio = sourceImage.size.width / sourceImage.size.height
        if sourceImage.size.width >= sourceImage.size.height {
            width = containingSize.width
            height = width / ratio
        } else {
            height = containingSize.height
            width = height * ratio
        }
        
        let imageSize = CGSize(width: width, height: height)
        println("Resized image: \(imageSize)")
        
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        sourceImage.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)
        printSizeOnDisk(imageData)
        imageData.writeToFile(path, atomically: true)
        
        finish()
    }
    
    func printSizeOnDisk(data: NSData) {
        let bytes = Int64(data.length)
        let size = NSByteCountFormatter.stringFromByteCount(bytes, countStyle: NSByteCountFormatterCountStyle.File)
        println("Size on disk: \(size)")
    }
}