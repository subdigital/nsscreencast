//
//  ActivityRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ActivityRingView : MetricRingView {
    
    override func setupView() {
        super.setupView()
        
        ringBackgroundColor = UIColor(red:0.29, green:0.05, blue:0.01, alpha:1.00)
        ringColor = UIColor(red:0.49, green:0.09, blue:0.03, alpha:1.00)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configureForLog(log: ActivityLog) {
        super.configureForLog(log)
        
        setAmount(log.activityProgress, forRingIdentifier: "ring")
        
        setColor(log.activityProgress >= 1.0 ? RingColors.Activity.highlightedColor : RingColors.Activity.baseColor, forRingIdentifier: "ring")
        
        setBackgroundColor(log.activityProgress >= 1.0, ringColor: .Activity)
        
        unitLabel.text = "CALS"
        valueLabel.text = "\(log.caloriesBurned)"
    }

}
