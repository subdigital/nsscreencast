//
//  ViewController.swift
//  AttachmentDemo
//
//  Created by Ben Scheirman on 9/29/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UIView!
    @IBOutlet var button: UIView!
    
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var buttonAttachment: UIAttachmentBehavior?
    
    @IBAction func buttonTapped(sender: AnyObject) {
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [button, label])
        var collision = UICollisionBehavior(items: [button, label])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collision)
        
        buttonAttachment = UIAttachmentBehavior(item: button,
            offsetFromCenter: UIOffsetMake(-5, 0),
            attachedToItem: label,
            offsetFromCenter: UIOffsetMake(20, 0))
        buttonAttachment?.damping = CGFloat.max
        
        var anchor = UIAttachmentBehavior(item: label,
            offsetFromCenter: UIOffsetMake( -1.0 * label.frame.size.width / 2.0, 0),
            attachedToAnchor: CGPointMake(label.frame.origin.x, label.frame.origin.y - 20))
        animator?.addBehavior(anchor)
        
        animator?.addBehavior(gravity)
        animator?.addBehavior(buttonAttachment)

        delay(2.0) {
            self.animator?.removeBehavior(self.buttonAttachment)
            
            self.delay(0.5) {
                self.animator?.removeBehavior(anchor)
                self.animator?.removeBehavior(collision)
            }
        }
        
    }
    
    func delay(seconds: Double, block: () -> ()) {
        let delay = seconds * Double(NSEC_PER_SEC)
        let time: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    

    
}

