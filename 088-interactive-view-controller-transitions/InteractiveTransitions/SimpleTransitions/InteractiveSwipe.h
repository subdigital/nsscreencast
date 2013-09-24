//
//  InteractiveSwipe.h
//  SimpleTransitions
//
//  Created by ben on 9/24/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveSwipe : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

- (void)attachToViewController:(UIViewController *)viewController;

@end
