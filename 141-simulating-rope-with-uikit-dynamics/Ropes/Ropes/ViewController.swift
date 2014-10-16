//
//  ViewController.swift
//  Ropes
//
//  Created by Ben Scheirman on 10/12/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var rope: Rope!
    var square: UIView!
    var panAttachment: UIAttachmentBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWorld()
        addRope()
    }
    
    func addRope() {
        let width: CGFloat = 4.0
        let height: CGFloat = 200.0
        let ropeFrame = CGRectMake(
            (view.frame.size.width - width) / 2.0,
            40.0,
            width,
            height)
        
        rope = Rope(frame: ropeFrame, numSegments: 6, referenceView: view)
        view.addSubview(rope)
        
        square = UIView(frame: CGRectMake(0, 0, 40, 40))
        square.center = CGPointMake(
            rope.frame.origin.x + rope.links.last!.center.x,
            rope.frame.origin.y + rope.links.last!.center.y + rope.segmentLength / 2.0)
        square.backgroundColor = UIColor.redColor()
        view.addSubview(square)
        square.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("pan:")))
        
        collision.addItem(square)
        gravity.addItem(square)
        
        for link in rope.links {
            gravity.addItem(link)
        }
        
        rope.addToAnimator(animator)
        
        var attachment = UIAttachmentBehavior(item: square, attachedToItem: rope.links.last!)
        animator.addBehavior(attachment)
    }
    
    func setupWorld() {
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }

    
    func pan(pan: UIPanGestureRecognizer) {
        let point = pan.locationInView(view)
        if pan.state == .Began {
            panAttachment = UIAttachmentBehavior(item: square,
                attachedToAnchor: point)
            animator.addBehavior(panAttachment)
            gravity.removeItem(square)
        } else if pan.state == .Changed {
            panAttachment.anchorPoint = point
        } else {
            animator.removeBehavior(panAttachment)
            gravity.addItem(square)
            panAttachment = nil
        }
        
    }
}

