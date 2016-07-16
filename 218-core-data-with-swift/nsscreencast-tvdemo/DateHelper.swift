//
//  DateHelper.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 4/24/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

class DateHelper {
    static var dateFormatterISO8601: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    class func parseDateISO8601(dateString: String) -> Decoded<NSDate> {
        if let date = dateFormatterISO8601.dateFromString(dateString) {
            return Decoded.Success(date)
        }
        
        return Decoded.Success(NSDate())
    }
}