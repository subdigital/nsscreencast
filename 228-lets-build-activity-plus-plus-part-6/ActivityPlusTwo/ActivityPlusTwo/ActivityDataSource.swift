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
    private let summaries: [HKActivitySummary]
    
    init(calendar: NSCalendar, summaries: [HKActivitySummary]) {
        self.calendar = calendar
        self.summaries = summaries
    }
    
    lazy var activities: [ActivityLog] = {
        return self.summaries.map { summary in
            return ActivityLog.fromHealthKitSummary(summary, calendar: self.calendar)
        }.sort { (x, y) in return x.date.compare(y.date) == NSComparisonResult.OrderedDescending }
    }()
}