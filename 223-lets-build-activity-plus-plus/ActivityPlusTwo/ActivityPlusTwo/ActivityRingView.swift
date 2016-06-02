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
        ringBackgroundColor = UIColor(red:0.29, green:0.05, blue:0.01, alpha:1.00)
        
        ringColor = UIColor(red:0.49, green:0.09, blue:0.03, alpha:1.00)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
