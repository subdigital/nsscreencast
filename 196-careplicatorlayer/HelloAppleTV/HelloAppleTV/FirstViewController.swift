//
//  FirstViewController.swift
//  HelloAppleTV
//
//  Created by Ben Scheirman on 11/1/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func launchRockets(sender: AnyObject) {
        let rocketImage = UIImage(named: "missile")!
    
        let rocket = CALayer()
        let size = rocketImage.size
        rocket.contents = rocketImage.CGImage
        rocket.frame = CGRect(x: -size.width, y: 100, width: size.width, height: size.height)
        
        let travel = CABasicAnimation(keyPath: "transform.translation.x")
        travel.duration = 1.5
        travel.fromValue = 0
        travel.toValue = view.frame.size.width + 400
        travel.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let wiggle = CABasicAnimation(keyPath: "transform.translation.y")
        wiggle.autoreverses = true
        wiggle.fromValue = 0
        wiggle.toValue = -94
        wiggle.duration = 0.35
        wiggle.repeatCount = Float.infinity
        wiggle.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let angle = CGFloat(M_PI / 16.0)
        
        rocket.transform = CATransform3DMakeRotation(-angle, 0, 0, 1.0)
        
        let wiggleRotation = CABasicAnimation(keyPath: "transform.rotation")
        wiggleRotation.beginTime = 0.08
        wiggleRotation.duration = wiggle.duration
        wiggleRotation.fromValue = -angle
        wiggleRotation.toValue = angle
        wiggleRotation.autoreverses = true
        wiggleRotation.repeatCount = Float.infinity
        
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = 10
        replicator.instanceDelay = 0.1
        replicator.instanceTransform = CATransform3DMakeTranslation(0, 90, 0)
        replicator.instanceTransform = CATransform3DRotate(replicator.instanceTransform, CGFloat(M_PI / 80.0), 0, 0, 1.0)
        replicator.instanceRedOffset = 0.5

        
        let anim = CAAnimationGroup()
        anim.animations = [ travel, wiggle, wiggleRotation ]
        anim.duration = travel.duration
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        
        view.layer.addSublayer(replicator)
        
        rocket.addAnimation(anim, forKey: "group")
        
        replicator.addSublayer(rocket)
    }
}
