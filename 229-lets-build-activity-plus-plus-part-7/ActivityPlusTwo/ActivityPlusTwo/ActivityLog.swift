//
//  ActivityLog.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import HealthKit

struct ActivityLog {
    let date: NSDate
    
    let caloriesBurned: Int
    let activityGoal: Int
    
    var activityProgress: CGFloat {
        return CGFloat(caloriesBurned) / CGFloat(activityGoal)
    }
    
    let minutesOfExercise: Int
    let exerciseGoal: Int
    
    var exerciseProgress: CGFloat {
        return CGFloat(minutesOfExercise) / CGFloat(exerciseGoal)
    }
    
    let standHours: Int
    let standGoal: Int
    
    var standProgress: CGFloat {
        return CGFloat(standHours) / CGFloat(standGoal)
    }
}

extension ActivityLog {
    static func fromHealthKitSummary(summary: HKActivitySummary, calendar: NSCalendar) -> ActivityLog {
        let dateComponents = summary.dateComponentsForCalendar(calendar)
        let date = calendar.dateFromComponents(dateComponents)!
        let caloriesBurned = summary.activeEnergyBurned.integerValueForUnit(.calorieUnit()) / 1000
        let calorieGoal = summary.activeEnergyBurnedGoal.integerValueForUnit(.calorieUnit()) / 1000
        let exerciseMin = summary.appleExerciseTime.integerValueForUnit(.minuteUnit())
        let exerciseGoal = summary.appleExerciseTimeGoal.integerValueForUnit(.minuteUnit())
        let standHours = summary.appleStandHours.integerValueForUnit(.countUnit())
        let standGoal = summary.appleStandHoursGoal.integerValueForUnit(.countUnit())
        
        let log = ActivityLog(date: date,
                              caloriesBurned: caloriesBurned,
                              activityGoal: calorieGoal,
                              minutesOfExercise: exerciseMin,
                              exerciseGoal: exerciseGoal,
                              standHours: standHours,
                              standGoal: standGoal)
        return log
    }
}

extension ActivityLog {
    static func randomSampleWithDate(date: NSDate, moveCompleted: Bool? = nil, exerciseCompleted: Bool? = nil, standCompleted: Bool? = nil) -> ActivityLog {
        
        func computeProgress(goal goal: Int, forceCompleted: Bool?) -> Int {
            if let completed = forceCompleted {
                return completed ? goal : 0
            } else {
                return Int(arc4random() % UInt32(Double(goal)*1.2))
            }
        }
        
        let calorieGoal = 500
        let caloriesBurned = computeProgress(goal: calorieGoal, forceCompleted: moveCompleted)
        
        let exerciseGoal = 30
        let exerciseMin = computeProgress(goal: exerciseGoal, forceCompleted: exerciseCompleted)
        
        let standGoal = 12
        let standHours = computeProgress(goal: standGoal, forceCompleted: standCompleted)
        
        
        return ActivityLog(date: date,
                           caloriesBurned: caloriesBurned,
                           activityGoal: calorieGoal,
                           minutesOfExercise: exerciseMin,
                           exerciseGoal: exerciseGoal,
                           standHours: standHours,
                           standGoal: standGoal)
    }
}


extension HKQuantity {
    func integerValueForUnit(unit: HKUnit) -> Int {
        return Int(doubleValueForUnit(unit))
    }
}