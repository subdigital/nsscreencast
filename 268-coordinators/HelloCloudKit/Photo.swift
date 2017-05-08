//
//  Photo.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 4/6/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit
import CloudKit

class Photo {
    static let recordType = "Photo"
    
    let record: CKRecord
    
    init(fullsizeImage: UIImage, thumbnail: UIImage, restaurantID: CKRecordID) {
        record = CKRecord(recordType: Photo.recordType)
        record["restaurant"] = CKReference(recordID: restaurantID, action: .deleteSelf)
        
        record["image"] = CKAsset(image: fullsizeImage, compression: 0.9)
        record["thumbnail"] = CKAsset(image: thumbnail, compression: 0.7)
    }
    
    
}
