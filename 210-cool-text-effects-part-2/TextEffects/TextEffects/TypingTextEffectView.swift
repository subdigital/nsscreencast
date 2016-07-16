//
//  TypingTextEffectView.swift
//  TextEffects
//
//  Created by Ben Scheirman on 2/23/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class TypingTextEffectView : TextEffectView {
    
    var letterDuration: NSTimeInterval = 0.25
    var letterDelay: NSTimeInterval = 0.1
    
    override func processGlyphLayer(layer: CAShapeLayer, atIndex index: Int) {
        layer.opacity = 0
        layer.fillColor = UIColor.darkGrayColor().CGColor
        layer.lineWidth = 0
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0
        opacityAnim.toValue = 1
        opacityAnim.duration = letterDuration
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnim.fromValue = -M_PI / 4.0
        rotateAnim.toValue = 0
        rotateAnim.duration = letterDuration / 2.0
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1.4, 0.9, 1.0]
        scaleAnim.keyTimes = [0, 0.75, 1.0]
        scaleAnim.duration = letterDuration
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnim, rotateAnim, scaleAnim]
        group.duration = letterDuration
        group.beginTime = CACurrentMediaTime() + Double(index) * letterDelay
        
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        
        layer.addAnimation(group, forKey: "animationGroup")
    }
}
