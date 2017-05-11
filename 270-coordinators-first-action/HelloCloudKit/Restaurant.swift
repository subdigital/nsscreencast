//
//  Restaurant.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/13/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

class Restaurant {
    static let recordType = "Restaurant"
    
    let name: String
    let address: String
    let location: CLLocation
    let imageFileURL: URL?
    
    var recordID: CKRecordID?
    
    init(record: CKRecord) {
        recordID = record.recordID
        name = record["name"] as! String
        address = record["address"] as! String
        location = record["location"] as! CLLocation
        if let asset = record["image"] as? CKAsset {
            imageFileURL = asset.fileURL
        } else {
            imageFileURL = nil
        }
    }
}


