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
    static func randomSampleWithDate(date: NSDate, moveCompleted: Bool = false, exerciseCompleted: Bool = false, standCompleted: Bool = false) -> ActivityLog {
        
        let caloriesBurned = moveCompleted ? 500 : Int(arc4random() % 800)
        let calorieGoal = 500
        
        let exerciseMin = exerciseCompleted ? 30 : Int(arc4random() % 45)
        let exerciseGoal = 30
        
        let standHours = standCompleted ? 12 : Int(arc4random() % 16)
        let standGoal = 12
        
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