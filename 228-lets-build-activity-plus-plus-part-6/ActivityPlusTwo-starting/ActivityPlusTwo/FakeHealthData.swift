//
//  FakeHealthData.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 7/12/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

struct FakeHealthData {
    static func randomSampleWithStreaks(calendar calendar: NSCalendar, startingWithDate date: NSDate) -> [ActivityLog] {
        let completedMovementRange: Range<Int> = (1..<5)
        let completedStandingRange: Range<Int> = (3...7)
        
        let randomSamples: [ActivityLog] = (0..<25).map { i in
            
            let moveCompleted = completedMovementRange.contains(i)
            let standCompleted = completedStandingRange.contains(i)
            
            let date = calendar.dateByAddingUnit(.Day, value: -i, toDate: date, options: [])!
            let log = ActivityLog.randomSampleWithDate(date, moveCompleted: moveCompleted, exerciseCompleted: false, standCompleted: standCompleted)
            return log
        }
        return randomSamples
    }
}
