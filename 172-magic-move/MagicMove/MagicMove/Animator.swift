//
//  Animator.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            animatePush(transitionContext)
        } else {
            animatePop(transitionContext)
        }
    }
    
    func getCellImageView(viewController: ViewController) -> UIImageView {
        let indexPath = viewController.lastSelectedIndexPath!
        let cell = viewController.collectionView!.cellForItemAtIndexPath(indexPath) as! ImageViewCell
        return cell.imageView
    }
    
    func animatePush(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! ViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! DetailViewController
        let container = transitionContext.containerView()
        
        toVC.view.layoutIfNeeded()
        
        let fromImageView = getCellImageView(fromVC)
        let toImageView = toVC.imageView
        
        let snapshot = fromImageView.snapshotViewAfterScreenUpdates(false)
        fromImageView.hidden = true
        toImageView.hidden = true
        
        let backdrop = UIView(frame: toVC.view.frame)
        backdrop.backgroundColor = toVC.view.backgroundColor
        container.addSubview(backdrop)
        backdrop.alpha = 0
        toVC.view.backgroundColor = UIColor.clearColor()
        
        toVC.view.alpha = 0
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        var frame = finalFrame
        frame.origin.y += frame.size.height
        toVC.view.frame = frame
        container.addSubview(toVC.view)
        
        snapshot.frame = container.convertRect(fromImageView.frame, fromView: fromImageView)
        container.addSubview(snapshot)
        
        UIView.animateWithDuration(transitionDuration(transitionContext)
            , animations: {

                backdrop.alpha = 1
                toVC.view.alpha = 1
                toVC.view.frame = finalFrame
                snapshot.frame = container.convertRect(toImageView.frame, fromView: toImageView)
                
            }, completion: { (finished) in
                
                toVC.view.backgroundColor = backdrop.backgroundColor
                backdrop.removeFromSuperview()
                
                fromImageView.hidden = false
                toImageView.hidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(finished)
        })
    }
    
    func animatePop(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! DetailViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as! ViewController
        let container = transitionContext.containerView()
        
        let fromImageView = fromVC.imageView
        let toImageView = getCellImageView(toVC)
        
        let snapshot = fromImageView.snapshotViewAfterScreenUpdates(false)
        fromImageView.hidden = true
        toImageView.hidden = true
        
        let backdrop = UIView(frame: fromVC.view.frame)
        backdrop.backgroundColor = fromVC.view.backgroundColor
        container.insertSubview(backdrop, belowSubview: fromVC.view)
        backdrop.alpha = 1
        fromVC.view.backgroundColor = UIColor.clearColor()
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.frame = finalFrame
        
        var frame = finalFrame
        frame.origin.y += frame.size.height
        container.insertSubview(toVC.view, belowSubview: backdrop)
        
        snapshot.frame = container.convertRect(fromImageView.frame, fromView: fromImageView)
        container.addSubview(snapshot)
        
        UIView.animateWithDuration(transitionDuration(transitionContext)
            , animations: {
                
                backdrop.alpha = 0
                fromVC.view.frame = frame
                snapshot.frame = container.convertRect(toImageView.frame, fromView: toImageView)
                
            }, completion: { (finished) in
                
                fromVC.view.backgroundColor = backdrop.backgroundColor
                backdrop.removeFromSuperview()
                
                fromImageView.hidden = false
                toImageView.hidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(finished)
        })
    }
}
