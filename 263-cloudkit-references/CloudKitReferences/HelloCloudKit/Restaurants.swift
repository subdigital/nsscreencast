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
}
