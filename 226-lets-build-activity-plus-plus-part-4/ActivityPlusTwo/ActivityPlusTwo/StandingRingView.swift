//
//  StandingRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class StandingRingView: MetricRingView {
    override func setupView() {
        super.setupView()
        
        ringBackgroundColor = UIColor(red:0.02, green:0.20, blue:0.30, alpha:1.00)
        ringColor = UIColor(red:0.04, green:0.34, blue:0.49, alpha:1.00)
    }
    
    override func configureForLog(log: ActivityLog) {
        super.configureForLog(log)
        
        setAmount(log.standProgress, forRingIdentifier: "ring")
        
        setColor(log.standProgress >= 1.0 ? RingColors.Standing.highlightedColor : RingColors.Standing.baseColor, forRingIdentifier: "ring")
        
      setBackgroundColor(log.standProgress >= 1.0, ringColor: .Standing)
        unitLabel.text = "HRS"
        valueLabel.text = "\(log.standHours)"
    }

    
}
