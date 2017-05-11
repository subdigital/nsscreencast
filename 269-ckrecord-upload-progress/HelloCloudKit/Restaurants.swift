//
//  Restaurants.swift
//  HelloCloudKit
//
//  Created by Ben Scheirman on 3/29/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation
import CloudKit

class Restaurants {
    static var container = CKContainer.default()
    
    static func all(completion: @escaping ([Restaurant], Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Restaurant.recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var results = [Restaurant]()
        queryOperation.recordFetchedBlock = { record in
            results.append(Restaurant(record: record))
        }
        queryOperation.queryCompletionBlock = { _, e in
            DispatchQueue.main.async {
                completion(results, e)
            }
        }
        
        container.publicCloudDatabase.add(queryOperation)
    }
    
    static func reviews(for restaurant: Restaurant, completion: @escaping ([Review], Error?) -> Void) {
        let ref = CKReference(recordID: restaurant.recordID!, action: .deleteSelf)
        let predicate = NSPredicate(format: "restaurant == %@", ref)
        let query = CKQuery(recordType: Review.recordType, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var results = [Review]()
        queryOperation.recordFetchedBlock = { record in
            results.append(Review(record: record))
        }
        queryOperation.queryCompletionBlock = { _, e in
            DispatchQueue.main.async {
                completion(results, e)
            }
        }
        
        container.publicCloudDatabase.add(queryOperation)
    }
    
    static func add(review: Review) {
        container.publicCloudDatabase.save(review.record) { (record, error) in
            if let e = error {
                print("Error saving review: \(e)")
            } else {
                print("Review saved")
            }
        }
    }
}
