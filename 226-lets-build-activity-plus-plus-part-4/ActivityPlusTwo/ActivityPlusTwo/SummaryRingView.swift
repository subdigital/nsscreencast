//
//  SummaryRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class SummaryRingView : RingView {
    
    var dateLabel: UILabel!
    var dayOfWeekLabel: UILabel!
    
    let dateFormatter = NSDateFormatter()
    let dayOfWeekFormatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = "d"
        dayOfWeekFormatter.dateFormat = "E"
        
        setupLabels()
        
        let startRadius: CGFloat = 30
        let gap: CGFloat = 1
        let strokeWidth: CGFloat = 3.0
        
        let totalStroke = 3*(strokeWidth+gap)
        
        backgroundView.color = RingColors.Summary.baseColor
        backgroundView.frame = CGRectInset(bounds, totalStroke, totalStroke)
        
        addRing("bg", radius: startRadius + strokeWidth + gap,
                color: RingColors.Summary.mutedColor,
                amount: 1.0,
                strokeWidth: totalStroke)
        
        addRing("standing", radius: startRadius, color: RingColors.Standing.baseColor, amount: 0.8, strokeWidth: strokeWidth)
        addRing("exercise", radius: startRadius + strokeWidth + gap, color: RingColors.Exercise.baseColor, amount: 0.4, strokeWidth: strokeWidth)
        addRing("activity", radius: startRadius + 2*(strokeWidth + gap), color: RingColors.Activity.baseColor, amount: 0.95, strokeWidth: strokeWidth)
    }
    
    private func setupLabels() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.boldSystemFontOfSize(22)
        dateLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        dateLabel.opaque = true
        addSubview(dateLabel)
        
        dateLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        dateLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 10).active = true
        
        dayOfWeekLabel = UILabel()
        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfWeekLabel.font = UIFont.systemFontOfSize(14)
        dayOfWeekLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        dayOfWeekLabel.opaque = true
        addSubview(dayOfWeekLabel)
        
        dayOfWeekLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        dayOfWeekLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -8).active = true
    }
    
    override func configureForLog(log: ActivityLog) {
        super.configureForLog(log)
        
        let strokeAttributes = [
            NSForegroundColorAttributeName:UIColor(white: 0.9, alpha: 1.0),
            NSStrokeColorAttributeName: RingColors.Summary.strokeColor,
            NSStrokeWidthAttributeName: -2
        ]
        
        dateLabel.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(log.date), attributes: strokeAttributes)
        dayOfWeekLabel.attributedText = NSAttributedString(string: dayOfWeekFormatter.stringFromDate(log.date), attributes: strokeAttributes)
        
        setAmount(log.activityProgress, forRingIdentifier: "activity")
        setAmount(log.standProgress, forRingIdentifier: "standing")
        setAmount(log.exerciseProgress, forRingIdentifier: "exercise")
        
        setColor(log.activityProgress >= 1.0 ? RingColors.Activity.highlightedColor : RingColors.Activity.baseColor, forRingIdentifier: "activity")
        setColor(log.standProgress >= 1.0 ? RingColors.Standing.highlightedColor : RingColors.Standing.baseColor, forRingIdentifier: "standing")
        setColor(log.exerciseProgress >= 1.0 ? RingColors.Exercise.highlightedColor : RingColors.Exercise.baseColor, forRingIdentifier: "exercise")
        
        
        let allComplete = log.activityProgress >= 1.0 &&
                          log.standProgress >= 1.0 &&
                          log.exerciseProgress >= 1.0
        let bgColor = allComplete ? RingColors.Summary.highlightedColor : RingColors.Summary.baseColor
        
        backgroundView.color = bgColor
        dateLabel.backgroundColor = bgColor
        dayOfWeekLabel.backgroundColor = bgColor
    }
}
