//
//  SwatchTransition.m
//  SimpleTransitions
//
//  Created by ben on 9/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "SwatchTransition.h"
const CGFloat SWATCH_PRESENT_DURATION = 1.5;
const CGFloat SWATCH_DISMISS_DURATION = 0.25;

@implementation SwatchTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.mode == SwatchTransitionModePresent ? SWATCH_PRESENT_DURATION : SWATCH_DISMISS_DURATION;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(- M_PI / 2);
    UIView *container = [transitionContext containerView];
    
    if (self.mode == SwatchTransitionModePresent) {
        [container addSubview:toVC.view];
        
        toVC.view.layer.anchorPoint = CGPointZero;
        toVC.view.frame = sourceRect;
        toVC.view.transform = rotation;
        
        [UIView animateWithDuration:SWATCH_PRESENT_DURATION
                              delay:0
             usingSpringWithDamping:0.25
              initialSpringVelocity:3
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             toVC.view.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    } else if(self.mode == SwatchTransitionModeDismiss) {
        [UIView animateWithDuration:SWATCH_DISMISS_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromVC.view.transform = rotation;
                         } completion:^(BOOL finished) {
                             [fromVC.view removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
}

@end
