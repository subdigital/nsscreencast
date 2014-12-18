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
        return Point(
            x: (1 - t) * p1.x + t * p2.x,
            y: (1 - t) * p1.y + t * p2.y
        )
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
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y)
        if control1 != nil {
            CGContextAddLineToPoint(context, control1!.x, control1!.y)
        }
        
        if control2 != nil {
            CGContextAddLineToPoint(context, control2!.x, control2!.y)
        }
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextStrokePath(context)
        
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
        
        // draw interpolated points
        if control1 != nil && control2 != nil && t > 0 {
            let t1 = interpolatePosition(startPoint, p2: control1!, t: t)
            let t2 = interpolatePosition(control1!, p2: control2!, t: t)
            let t3 = interpolatePosition(control2!, p2: endPoint, t: t)
            
            drawPoint(context, point: t1, color: UIColor.greenColor(), radius: 4)
            drawPoint(context, point: t2, color: UIColor.greenColor(), radius: 4)
            drawPoint(context, point: t3, color: UIColor.greenColor(), radius: 4)
            
            CGContextMoveToPoint(context, t1.x, t1.y)
            CGContextAddLineToPoint(context, t2.x, t2.y)
            CGContextAddLineToPoint(context, t3.x, t3.y)
            CGContextSetStrokeColorWithColor(context, UIColor(white: 0.8, alpha: 1.0).CGColor)
            CGContextStrokePath(context)
            
            let u1 = interpolatePosition(t1, p2: t2, t: t)
            let u2 = interpolatePosition(t2, p2: t3, t: t)
            
            drawPoint(context, point: u1, color: UIColor.purpleColor(), radius: 4)
            drawPoint(context, point: u2, color: UIColor.purpleColor(), radius: 4)
            
            CGContextMoveToPoint(context, u1.x, u1.y)
            CGContextAddLineToPoint(context, u2.x, u2.y)
            CGContextSetStrokeColorWithColor(context, UIColor(white: 0.7, alpha: 1.0).CGColor)
            CGContextStrokePath(context)
            
            let v1 = interpolatePosition(u1, p2: u2, t: t)
            drawPoint(context, point: v1, color: UIColor.orangeColor(), radius: 4)
        }
    }
}
