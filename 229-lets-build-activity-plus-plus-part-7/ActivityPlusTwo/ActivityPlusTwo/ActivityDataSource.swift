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

enum MetricType {
    case Movement
    case Exercise
    case Standing
}

struct Streak {
    let metric: MetricType
    let startingDate: NSDate
    let numberOfDays: Int
}

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
    
    lazy var streaks: [Streak] = {
        var streaks: [Streak] = []
        
        var potentialStreaks: [MetricType: Int] = [:]
        
        var lookup: [MetricType : (ActivityLog) -> Bool] = [
            .Movement : { $0.activityProgress >= 1.0 },
            .Exercise : { $0.exerciseProgress >= 1.0 },
            .Standing : { $0.standProgress >= 1.0 }
        ]
        
        for activity in self.activities {
            for metric in lookup.keys {
                let hasCompletedMetric = lookup[metric]!(activity)
                if hasCompletedMetric {
                    let numberOfDays = (potentialStreaks[metric] ?? 0) + 1
                    potentialStreaks[metric] = numberOfDays
                } else {
                    if let numberOfDays = potentialStreaks[metric] where numberOfDays > 1 {
                        streaks.append(Streak(metric: metric,
                            startingDate: activity.date,
                            numberOfDays: numberOfDays))
                    }
                    potentialStreaks[metric] = nil
                }
            }
        }
        
        return streaks
    }()
}