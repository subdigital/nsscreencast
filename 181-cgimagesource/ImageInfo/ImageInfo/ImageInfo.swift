//
//  ImageInfo.swift
//  ImageInfo
//
//  Created by Ben Scheirman on 8/4/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import ImageIO

struct ImageInfo {
    
    let properties: NSDictionary
    
    var imageWidth: Int? {
        return getValue(kCGImagePropertyPixelWidth)
    }
    
    var imageHeight: Int? {
        return getValue(kCGImagePropertyPixelHeight)
    }
    
    var cameraModel: String? {
        return getNestedValue(kCGImagePropertyTIFFDictionary, key: kCGImagePropertyTIFFModel)
    }
    
    var lens: String? {
        return getNestedValue(kCGImagePropertyExifAuxDictionary, key: kCGImagePropertyExifAuxLensModel)
    }
    
    var fStop: Float? {
        return getNestedValue(kCGImagePropertyExifDictionary, key: kCGImagePropertyExifFNumber)
    }
    
    var iso: Int? {
        if let isos: [Int] = getNestedValue(kCGImagePropertyExifDictionary, key: kCGImagePropertyExifISOSpeedRatings) {
            return isos.first
        }
        return nil
    }
    
    init(imageProperties: NSDictionary) {
        properties = imageProperties
    }
    
    private func getValue<T>(key: CFString) -> T? {
        return properties[key as! String] as? T
    }
    
    private func getNestedValue<T>(group: CFString, key: CFString) -> T? {
        if let group: NSDictionary = getValue(group) {
            return group[key as! String] as? T
        }
        return nil
    }
}

