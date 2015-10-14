//
//  FilterImageOperation.swift
//  HubbleViewer
//
//  Created by Ben Scheirman on 7/7/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Foundation
import CoreImage

class FilterImageOperation : Operation {
    let path: String
    var outputImage: CIImage?
    
    init(path: String) {
        self.path = path
    }
    
    lazy var inputImage: CIImage = {
        let url = NSURL(fileURLWithPath: self.path)
        return CIImage(contentsOfURL: url)!
    }()
    
    lazy var filter: CIFilter = {
        return CIFilter(name: "CISepiaTone", withInputParameters: [
            kCIInputImageKey : self.inputImage
        ])!
    }()
    
    override func execute() {
        outputImage = filter.outputImage
        finish()
    }
}
