//
//  SlidePopContainerViewController.m
//  SlidePopExample
//
//  Created by ben on 3/19/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "SlidePopContainerViewController.h"

#define ANIMATION_DURATION 1.0

@interface SlidePopContainerViewController ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation SlidePopContainerViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)addController:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
}

- (UIViewController *)topMostViewController {
    return [self.childViewControllers lastObject];
}

- (void)pushViewController:(UIViewController *)viewController {
    UIViewController *topVC = [self topMostViewController];
    
    [self addController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    viewController.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        topVC.view.alpha = 0.5;
        topVC.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
        viewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [viewController didMoveToParentViewController:self];
    }];
}

- (void)popViewController {
    int index = [self.childViewControllers count] - 2;
    UIViewController *targetVC = self.childViewControllers[index];
    UIViewController *topVC = [self topMostViewController];
    
    [topVC willMoveToParentViewController:nil];
    
    
    CGAffineTransform previousTransform = targetVC.view.transform;
    targetVC.view.transform = CGAffineTransformIdentity;
    targetVC.view.frame = self.view.bounds;
    targetVC.view.transform = previousTransform;
    
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        targetVC.view.alpha = 1.0;
        targetVC.view.transform = CGAffineTransformIdentity;
        topVC.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [topVC.view removeFromSuperview];
        [topVC removeFromParentViewController];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    
    if ([self.childViewControllers count] == 0) {
        [self addController:self.rootViewController];
        UIView *rootView = self.rootViewController.view;
        rootView.frame = self.view.bounds;
        [self.view addSubview:rootView];
        [self.rootViewController didMoveToParentViewController:self];
    }
}

@end


@implementation UIViewController (SlidePopContainer)

- (SlidePopContainerViewController *)slidePopContainer {
    return (SlidePopContainerViewController *)self.parentViewController;
}

@end
