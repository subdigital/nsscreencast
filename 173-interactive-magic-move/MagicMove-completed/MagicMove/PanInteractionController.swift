//
//  InteractionController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/3/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

protocol PanInteractionControllerDelegate {
    func interactiveAnimationDidStart(controller: PanInteractionController)
}

class PanInteractionController : UIPercentDrivenInteractiveTransition {
    var delegate: PanInteractionControllerDelegate?
    var pan: UIPanGestureRecognizer?
    
    func attachToView(view: UIView) {
        updateInteractiveTransition(0)
        pan = UIPanGestureRecognizer(target: self, action: Selector("screenEdgePan:"))
        view.addGestureRecognizer(pan!)
    }
    
    func screenEdgePan(recognizer: UIPanGestureRecognizer) {
        let view = recognizer.view
        
        switch recognizer.state {
        case .Began:
            let location = recognizer.locationInView(view!)
            if location.x < CGRectGetMidX(view!.bounds) {
                delegate?.interactiveAnimationDidStart(self)
            }
            
        case .Changed:
            let translation = recognizer.translationInView(view!)
            let percent = fabs(translation.x / CGRectGetWidth(view!.bounds))
            updateInteractiveTransition(percent)
            
        case .Ended:
            if recognizer.velocityInView(view!).x > 0 {
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
            
        case .Cancelled: fallthrough
        case .Failed:
            cancelInteractiveTransition()
            
        case .Possible:
            break
        }
    }

}

