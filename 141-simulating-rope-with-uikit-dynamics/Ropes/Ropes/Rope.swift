//
//  Rope.swift
//  Ropes
//
//  Created by Ben Scheirman on 10/12/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class Rope : UIView {
    var numSegments: Int = 1
    var links: [UIView] = []
    var originalFrame = CGRectZero
    
    var segmentWidth: CGFloat {
        get {
            return originalFrame.size.width
        }
    }
    
    var segmentLength: CGFloat {
        get {
            return originalFrame.size.height / CGFloat(numSegments)
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, numSegments: Int, referenceView: UIView) {
        self.numSegments = numSegments
        self.originalFrame = frame
        
        super.init(frame: referenceView.frame)
        
        clipsToBounds = false
        backgroundColor = UIColor.clearColor()
        addLinks()
    }
    
    func addLinks() {
        for var i = 0; i < numSegments; i++ {
            let linkFrame = CGRectMake(
                originalFrame.origin.x + 0,
                originalFrame.origin.y + CGFloat(i) * segmentLength,
                segmentWidth,
                segmentLength
            )
            var link = UIView(frame: linkFrame)
            link.backgroundColor = UIColor.clearColor()
            addSubview(link)
            links.append(link)
        }
    }
    
    func addToAnimator(animator: UIDynamicAnimator) {
        for (index, link) in enumerate(links) {
            var attachment: UIAttachmentBehavior!
            if index == 0 {
                attachment = UIAttachmentBehavior(item: link,
                    offsetFromCenter: UIOffsetMake(0, -segmentLength/2.0),
                    attachedToAnchor: originalFrame.origin)
            } else {
                let previousLink = links[index-1]
                attachment = UIAttachmentBehavior(item: link,
                    offsetFromCenter: UIOffsetMake(0, -segmentLength/2.0),
                    attachedToItem: previousLink,
                    offsetFromCenter: UIOffsetMake(0, segmentLength/2.0))
            }
         
            attachment.length = 1
            attachment.damping = 1
            attachment.frequency = 10
            attachment.action = {
                self.setNeedsDisplay()
            }
            animator.addBehavior(attachment)
        }
    }
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath()
        path.lineCapStyle = kCGLineCapRound
        path.lineJoinStyle = kCGLineJoinRound
        path.lineWidth = segmentWidth
        
        var start = links.first!.center
        start.y -= segmentLength / 2.0
        path.moveToPoint(start)
        for link in links {
            if link == links.first! {
                continue
            }
            path.addLineToPoint(link.center)
        }
        UIColor.blueColor().setStroke()
        path.stroke()
    }
}
