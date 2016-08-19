//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
view.backgroundColor = .lightGrayColor()

let facetimePreview = UIView(frame: CGRect(x: 20, y: 20, width: 80, height: 100))
facetimePreview.backgroundColor = .darkGrayColor()
facetimePreview.layer.cornerRadius = 4

view.addSubview(facetimePreview)

class Handler: NSObject, UIGestureRecognizerDelegate {
    let view: UIView
    var offset = CGPoint.zero

    init(view: UIView) {
        self.view = view
    }
    
    func installGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(Handler.onPan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(Handler.onTap(_:)))
        tap.minimumPressDuration = 0
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func onTap(recognizer: UITapGestureRecognizer) {
        print(recognizer.state)
        switch recognizer.state {
        case .Began: fallthrough
        case .Changed:
            recognizer.view?.backgroundColor = UIColor.redColor()
        
        default:
            recognizer.view?.backgroundColor = UIColor.darkGrayColor()
        }
    }
    
    func computeTargetPoint(view: UIView, location: CGPoint, velocity: CGPoint, bounds: CGRect) -> CGPoint {
        let targetX: CGFloat
        let targetY: CGFloat
        let threshold: CGFloat = 20.0
        let Margin: CGFloat = 20.0
        
        let goLeft: Bool
        let goUp: Bool
        
        if fabs(velocity.x) > threshold {
            goLeft = velocity.x < -threshold
        } else {
            goLeft = location.x < CGRectGetMidX(bounds)
        }
        
        if fabs(velocity.y) > threshold {
            goUp = velocity.y < -threshold
        } else {
            goUp = location.y < CGRectGetMidX(bounds)
        }
        
        if goLeft {
            targetX = Margin + CGRectGetMidX(view.bounds)
        } else {
            targetX = CGRectGetMaxX(bounds) - CGRectGetMidX(view.bounds) - Margin
        }
        
        if goUp {
            targetY = Margin + CGRectGetMidY(view.bounds)
        } else {
            targetY = CGRectGetMaxY(bounds) - CGRectGetMidY(view.bounds) - Margin
            
        }
        
        return CGPoint(x: targetX, y: targetY)
    }
    
    @objc func onPan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(view)
        let parent = view.superview!
        let locationInParent = recognizer.locationInView(parent)
        let centerInParent = CGPointMake(locationInParent.x + offset.x, locationInParent.y + offset.y)
        
        switch recognizer.state {
        case .Began:
            offset = CGPointMake(
                CGRectGetMidX(view.bounds) - location.x,
                CGRectGetMidY(view.bounds) - location.y)
            
        case .Changed:
            view.center = centerInParent
            
        case .Ended:
            let velocity = recognizer.velocityInView(parent)
            print(velocity)
            
            let targetPoint = computeTargetPoint(view, location: centerInParent, velocity: velocity, bounds: parent.bounds)
            
            func magnitude(vector: CGPoint) -> CGFloat {
                return sqrt(pow(vector.x, 2) + pow(vector.y, 2))
            }

            let distanceVector = CGPoint(x: centerInParent.x - targetPoint.x, y: centerInParent.y - targetPoint.y)
            let totalDistance = magnitude(distanceVector)
            let magVelocity = magnitude(velocity)
            
            let animationDuration: NSTimeInterval = 1
            let springVelocity: CGFloat = magVelocity / totalDistance / CGFloat(animationDuration)
            
            
            UIView.animateWithDuration(animationDuration,
                                       delay: 0,
                                       usingSpringWithDamping: 0.9,
                                       initialSpringVelocity: springVelocity,
                                       options: [],
                                       animations: {
                recognizer.view!.center = targetPoint
            }, completion: nil)
            
            
        default:
            break;
        }
    }
}





let handler = Handler(view: facetimePreview)
handler.installGestureRecognizers()

let page = XCPlaygroundPage.currentPage
page.liveView = view
page.needsIndefiniteExecution = true

