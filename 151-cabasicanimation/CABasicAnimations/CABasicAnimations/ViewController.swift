//
//  ViewController.swift
//  CABasicAnimations
//
//  Created by Ben Scheirman on 1/5/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var layer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRectMake(0, 0, 100, 100)).CGPath
        layer.frame = CGRectMake(0, 0, 100, 100)
        layer.position = self.view.center
        layer.fillColor = UIColor.redColor().CGColor
        return layer
    }()
    
    var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.layer.addSublayer(layer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tap:")))
    }
    
    func trianglePath() -> CGPathRef {
        let path = UIBezierPath()
        let w = layer.bounds.size.width
        let h = layer.bounds.size.height
        path.moveToPoint(CGPointMake(w/2, 0))
        path.addLineToPoint(CGPointMake(w/2, 0))
        path.addLineToPoint(CGPointMake(w, h))
        path.addLineToPoint(CGPointMake(0, h))
        path.closePath()
        return path.CGPath
    }
    
    func tap(sender: UITapGestureRecognizer) {
        // implicit animation
//        layer.backgroundColor = UIColor.blueColor().CGColor
//        layer.frame = CGRectMake(10, 10, 80, 80)
        
        let anim = CABasicAnimation(keyPath: "fillColor")
        anim.fromValue = UIColor.darkGrayColor().CGColor
        anim.toValue = UIColor.purpleColor().CGColor
        anim.repeatCount = 10
        anim.duration = 1.5
        anim.autoreverses = true
        layer.addAnimation(anim, forKey: "colorAnimation")
        
        layer.fillColor = anim.fromValue as CGColorRef
        
        let posAnim = CABasicAnimation(keyPath: "position.x")
        posAnim.fromValue = layer.bounds.size.width / 2
        posAnim.toValue = view.frame.size.width - layer.bounds.size.width / 2
        posAnim.duration = anim.duration
        posAnim.repeatCount = 3
        posAnim.autoreverses = true
        posAnim.delegate = self
        posAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.addAnimation(posAnim, forKey: "position")
        
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = layer.path
        pathAnim.toValue = trianglePath()
        pathAnim.duration = 4
        pathAnim.autoreverses = true
        pathAnim.repeatCount = HUGE
        layer.addAnimation(pathAnim, forKey: "pathAnimation")
////
//
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.25,
//            target: self,
//            selector: Selector("tick"),
//            userInfo: nil,
//            repeats: true)
    }
    
    func tick() {
        println("x: \(layer.presentationLayer()?.position.x)")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        timer?.invalidate()
    }
}

