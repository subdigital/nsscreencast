//
//  ActivityCell.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 6/21/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ActivityCell : UICollectionViewCell {
    
    @IBOutlet weak var summaryRing: SummaryRingView!
    @IBOutlet weak var activityRing: ActivityRingView!
    @IBOutlet weak var exerciseRing: ExerciseRingView!
    @IBOutlet weak var standingRing: StandingRingView!
    
    var rings: [RingView] {
        return [summaryRing, activityRing, exerciseRing, standingRing]
    }
    
    func configureForLog(log: ActivityLog) {
        rings.forEach { $0.configureForLog(log) }      
    }
}
