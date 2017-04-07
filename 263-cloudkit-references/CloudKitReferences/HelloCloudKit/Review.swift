//
//  Review.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/31/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import CloudKit

class Review {
    static let recordType = "Review"
    
    let authorName: String
    let comment: String
    let rating: Float
    let restaurantReference: CKReference
    
    var recordID: CKRecordID?
    let record: CKRecord
    
    init(record: CKRecord) {
        self.record = record
        recordID = record.recordID
        authorName = record["author_name"] as! String
        comment = record["comment"] as! String
        rating = (record["stars"] as! NSNumber).floatValue
        restaurantReference = record["restaurant"] as! CKReference
    }
    
    convenience init(author: String, comment: String, rating: Float, restaurantID: CKRecordID) {
        let record = CKRecord(recordType: Review.recordType)
        record["author_name"] = author as NSString
        record["comment"] = comment as NSString
        record["stars"] = rating as NSNumber
        record["restaurant"] = CKReference(recordID: restaurantID, action: .deleteSelf)
        self.init(record: record)
    }
}
