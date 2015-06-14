//
//  PanInteractionController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/4/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

protocol PanInteractionControllerDelegate {
    func interactiveAnimationDidStart(controller: PanInteractionController)
}

class PanInteractionController : UIPercentDrivenInteractiveTransition {
    var pan: UIPanGestureRecognizer?
    var delegate: PanInteractionControllerDelegate?
    
    var isActive: Bool {
        get {
            return pan?.state != .Possible
        }
    }
    
    func attachToView(view: UIView) {
        pan = UIPanGestureRecognizer(target: self, action: Selector("screenEdgePan:"))
        view.addGestureRecognizer(pan!)
    }
    
    func screenEdgePan(pan: UIScreenEdgePanGestureRecognizer) {
        let view = pan.view!
        switch pan.state {
        case .Began:
            let location = pan.locationInView(view)
            if location.x < CGRectGetMidX(view.bounds) {
                delegate?.interactiveAnimationDidStart(self)
            }
            
        case .Changed:
            let translation = pan.translationInView(view)
            let percent = fabs(translation.x / CGRectGetWidth(view.bounds))
            updateInteractiveTransition(percent)
            
        case .Ended:
            if pan.velocityInView(view).x > 0 {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
            
        case .Cancelled: fallthrough
        case .Failed:
            cancelInteractiveTransition()
            
        case .Possible: break
            
        }
    }

}
