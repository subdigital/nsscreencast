//
//  ViewController.swift
//  BezierPaths
//
//  Created by Ben Scheirman on 12/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum ControlPoint {
        case Control1
        case Control2
        case None
    }
    
    // properties
    var control1: CGPoint?
    var control2: CGPoint?
    var points: NSMutableSet!
    var draggingPoint: Point?
    var lineView: LineView!

    // outlets & actions

    @IBAction func showLineChanged(sender: UISwitch) {
        lineView.showLine = sender.on
        lineView.setNeedsDisplay()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        lineView.t = CGFloat(sender.value)
        lineView.setNeedsDisplay()
    }
    
    // view lifecycle
    
    override func viewDidLoad() {
        points = NSMutableSet()
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        let doubleTap = UITapGestureRecognizer(target: self, action: Selector("doubleTap:"))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        let pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        lineView = LineView(frame: view.bounds)
        lineView.userInteractionEnabled = false
        view.addSubview(lineView)
    }
    
    
    // gesture recognizer
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        // ignore gestures at the bottom
        if gestureRecognizer.locationInView(view).y > view.frame.size.height - 80 {
            return false
        }
        
        return true
    }
    
    func tap(tap: UITapGestureRecognizer) {
        let loc = tap.locationInView(view)
        
        if pointAtLocation(loc) != .None {
            return
        }
        
        if lineView.control1 == nil {
            lineView.control1 = Point(x: loc.x, y: loc.y)
            lineView.setNeedsDisplay()
        } else if control2 == nil {
            lineView.control2 = Point(x: loc.x, y: loc.y)
            lineView.setNeedsDisplay()
        } else {
            // we already have our points
            return
        }
    }
    
    func doubleTap(tap: UITapGestureRecognizer) {
        let loc = tap.locationInView(view)
        switch pointAtLocation(loc) {
        case .Control1:
            lineView.control1 = nil
            
        case .Control2:
            lineView.control2 = nil
            
        case .None:
            lineView.control1 = nil
            lineView.control2 = nil
        }
        
        lineView.setNeedsDisplay()
    }
    
    func pan(pan: UIPanGestureRecognizer) {
        switch pan.state {
            
        case UIGestureRecognizerState.Began:
            switch pointAtLocation(pan.locationInView(view)) {
            case .Control1: draggingPoint = lineView.control1
            case .Control2: draggingPoint = lineView.control2
            case .None: draggingPoint = nil
            }
            
        case UIGestureRecognizerState.Changed:
            if draggingPoint == nil {
                return
            }
            
            let offset = pan.translationInView(view)
            if draggingPoint != nil {
                var newPoint = draggingPoint!
                newPoint.x += offset.x
                newPoint.y += offset.y
                
                if draggingPoint == lineView.control1 {
                    lineView.control1 = newPoint
                } else {
                    lineView.control2 = newPoint
                }
                
                lineView.setNeedsDisplay()
            }
            pan.setTranslation(CGPointZero, inView: view)
            
        case UIGestureRecognizerState.Ended:
            draggingPoint = nil
            
        case UIGestureRecognizerState.Cancelled:
            draggingPoint = nil
            
        default:
            draggingPoint = nil
        }
    }
    
    
    // utility
    
    func pointAtLocation(location: CGPoint) -> ControlPoint {
        
        for point in [lineView.control1, lineView.control2] {
            if let p = point {
                let radius: CGFloat = 20
                let clickRect = CGRectMake(p.x - radius, p.y - radius, radius * 2, radius * 2)
                if CGRectContainsPoint(clickRect, location) {
                    if p == lineView.control1 {
                        return .Control1
                    } else if p == lineView.control2 {
                        return .Control2
                    } else {
                        println("Should always be either control1 or control2")
                        abort()
                    }
                }
            }
        }
        return .None
    }
}

