//
//  Review.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/29/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

struct Review {
    static let recordType = "Review"
    
    let authorName: String
    let comment: String
    let stars: Float
    let restaurantReference: CKReference
    
    let record: CKRecord
    
    var recordID: CKRecordID?
    
    init(record: CKRecord) {
        self.record = record
        recordID = record.recordID
        authorName = record["author_name"] as! String
        comment = record["comment"] as! String
        stars = (record["stars"] as! NSNumber).floatValue
        restaurantReference = record["restaurant"] as! CKReference
    }
    
    init(author: String, comment: String, rating: Float, restaurantID: CKRecordID) {
        let record = CKRecord(recordType: Review.recordType)
        record["author_name"] = author as NSString
        record["comment"] = comment as NSString
        record["stars"] = rating as NSNumber
        record["restaurant"] = CKReference(recordID: restaurantID, action: .deleteSelf)
        self.init(record: record)
    }
}
