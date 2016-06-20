//
//  ActivityLog.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

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