//
//  CKAsset+UIImage.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 4/6/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension CKAsset {
    convenience init(image: UIImage, compression: CGFloat) {
        let fileURL = ImageHelper.saveToDisk(image: image, compression: compression)
        self.init(fileURL: fileURL)
    }
    
    var image: UIImage? {
        guard let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data) else {
                return nil
        }
        
        return image
    }
}
