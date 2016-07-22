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
    
    var valueLabel: UILabel!
    var unitLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabels()
        
        let strokeWidth: CGFloat = 10
        let radius = CGRectGetWidth(bounds) / 2 - strokeWidth/2
        
        backgroundView.frame = CGRectInset(bounds, strokeWidth, strokeWidth)
        
        if let bgColor = ringBackgroundColor {
            backgroundView.color = bgColor
        }
        
        addRing("ring", radius: radius, color: ringColor ?? UIColor.whiteColor(), amount: 0.5, strokeWidth: strokeWidth)
    }
    
    private func setupLabels() {
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFontOfSize(20)
        valueLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        valueLabel.opaque = true
        addSubview(valueLabel)
        
        valueLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        valueLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: -10).active = true
        
        unitLabel = UILabel()
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.systemFontOfSize(14)
        unitLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        unitLabel.opaque = true
        addSubview(unitLabel)
        
        unitLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        unitLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 8).active = true
    }
    
    
    func setBackgroundColor(completed: Bool, ringColor: RingColors) {
        let bgColor = completed ? ringColor.baseColor : ringColor.mutedColor
        backgroundView.color = bgColor
        unitLabel.backgroundColor = bgColor
        valueLabel.backgroundColor = bgColor
    }
}
