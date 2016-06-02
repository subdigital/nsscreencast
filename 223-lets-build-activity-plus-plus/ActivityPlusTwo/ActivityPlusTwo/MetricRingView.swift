//
//  MetricRingView.swift
//  ActivityPlusTwo
//
//  Created by NSScreencast on 5/31/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class MetricRingView : RingView {
    
    var ringColor: UIColor?
    var ringBackgroundColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        // override
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let strokeWidth: CGFloat = 10
        let radius = CGRectGetWidth(bounds) / 2 - strokeWidth/2
        
        backgroundView.frame = CGRectInset(bounds, strokeWidth, strokeWidth)
        
        if let bgColor = ringBackgroundColor {
            backgroundView.color = bgColor
        }
        
        addRing("ring", radius: radius, color: ringColor ?? UIColor.whiteColor(), amount: 0.5, strokeWidth: strokeWidth)
    }
    
}
