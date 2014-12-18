//
//  LineView.swift
//  BezierPaths
//
//  Created by Ben Scheirman on 12/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    var t: CGFloat = 0
    
    var showLine: Bool = true

    var startPoint: Point!
    var endPoint: Point!
    var control1: Point?
    var control2: Point?

    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let margin: CGFloat = 20
        startPoint = Point(x: margin, y: frame.size.height / 2)
        endPoint = Point(x: frame.size.width - margin, y: frame.size.height / 2)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func interpolatePosition(p1: Point, p2: Point, t: CGFloat) -> Point {
        return Point()
    }
    
    func drawPoint(context: CGContextRef, point: Point, color: UIColor, radius: CGFloat = 4, outlineColor: UIColor? = nil) {
        let rect = CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, rect)
        
        if let outline = outlineColor {
            CGContextSetStrokeColorWithColor(context, outline.CGColor)
            CGContextSetLineWidth(context, 1)
            CGContextStrokeEllipseInRect(context, rect)
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        if showLine {
            // draw blue line
            CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
            CGContextSetLineWidth(context, 4)
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            CGContextAddCurveToPoint(context,
                (control1 ?? startPoint).x,
                (control1 ?? startPoint).y,
                (control2 ?? endPoint).x,
                (control2 ?? endPoint).y,
                endPoint.x,
                endPoint.y
            )
            CGContextStrokePath(context)
        }
        
        // draw end points
        for p in [startPoint, endPoint] {
            drawPoint(context, point: p, color: UIColor.redColor(), radius: 10)
        }
        
        // draw control points
        for control in [control1, control2] {
            if let c = control {
                drawPoint(context, point: c, color: UIColor.lightGrayColor(), radius: 6, outlineColor: UIColor.darkGrayColor())
            }
        }
    }
}
