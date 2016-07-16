//
//  ActivityDataSource.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 7/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

struct ActivityDataSource {
    private let calendar: NSCalendar
    var activities: [ActivityLog]!
    
    init(calendar: NSCalendar, summaries: [HKActivitySummary]) {
        self.calendar = calendar
        self.activities = _convert(summaries)
    }
    
    init(calendar: NSCalendar, activities: [ActivityLog]) {
        self.calendar = calendar
        self.activities = activities
    }
    
    private func _convert(summaries: [HKActivitySummary]) -> [ActivityLog] {
        return summaries.map { summary in
            return ActivityLog.fromHealthKitSummary(summary, calendar: self.calendar)
            }.sort { (x, y) in return x.date.compare(y.date) == NSComparisonResult.OrderedDescending }

    }
}