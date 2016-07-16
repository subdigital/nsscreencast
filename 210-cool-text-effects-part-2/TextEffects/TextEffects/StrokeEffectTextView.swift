//
//  StrokeEffectTextView.swift
//  TextEffects
//
//  Created by Ben Scheirman on 2/23/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class StrokeEffectTextView : TextEffectView {
    override func processGlyphLayer(layer: CAShapeLayer, atIndex index: Int) {
        layer.strokeStart = 0
        layer.strokeEnd = 0
        
        layer.strokeColor = UIColor.blackColor().CGColor
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.lineWidth = 1
        layer.lineJoin = kCALineJoinBevel
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.duration = 0.5
        anim.beginTime = CACurrentMediaTime() + Double(index) * anim.duration
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        layer.addAnimation(anim, forKey: "strokeAnim")
    }
}
