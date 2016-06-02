//
//  SummaryRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class SummaryRingView : RingView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let startRadius: CGFloat = 30
        let gap: CGFloat = 1
        let strokeWidth: CGFloat = 3.0
        
        let totalStroke = 3*(strokeWidth+gap)
        
        backgroundView.color = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        backgroundView.frame = CGRectInset(bounds, totalStroke, totalStroke)
        
        addRing("bg", radius: startRadius + strokeWidth + gap, color: UIColor(white: 0.15, alpha: 1.0),
        amount: 1.0, strokeWidth: totalStroke)
        
        addRing("standing", radius: startRadius, color: UIColor.blueColor(), amount: 0.8, strokeWidth: strokeWidth)
        addRing("exercise", radius: startRadius + strokeWidth + gap, color: UIColor.greenColor(), amount: 0.4, strokeWidth: strokeWidth)
        addRing("activity", radius: startRadius + 2*(strokeWidth + gap), color: UIColor.redColor(), amount: 0.95, strokeWidth: strokeWidth)

    }
}
