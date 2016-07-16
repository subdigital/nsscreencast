//
//  ExerciseRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ExerciseRingView : MetricRingView {
    
    override func setupView() {
        super.setupView()
        
        ringBackgroundColor = UIColor(red:0.05, green:0.29, blue:0.03, alpha:1.00)
        ringColor = UIColor(red:0.11, green:0.49, blue:0.07, alpha:1.00)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func configureForLog(log: ActivityLog) {
        super.configureForLog(log)
        
        setAmount(log.exerciseProgress, forRingIdentifier: "ring")
        
        setColor(log.exerciseProgress >= 1.0 ? RingColors.Exercise.highlightedColor : RingColors.Exercise.baseColor, forRingIdentifier: "ring")
        
        setBackgroundColor(log.exerciseProgress >= 1.0, ringColor: .Exercise)
        
        unitLabel.text = "MINS"
        valueLabel.text = "\(log.minutesOfExercise)"
    }

}
