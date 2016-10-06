//
//  ImageCache.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class ImageCache {
    private var internalCache = NSCache<NSString, UIImage>()
    
    static var shared = ImageCache()
    
    func image(forURL url: URL) -> UIImage? {
        return internalCache.object(forKey: url.absoluteString as NSString)
    }
    
    func set(image: UIImage, url: URL) {
        internalCache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
