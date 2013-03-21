//
//  SlidePopContainerViewController.h
//  SlidePopExample
//
//  Created by ben on 3/19/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidePopContainerViewController : UIViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

@end

@interface UIViewController (SlidePopContainer)

@property (nonatomic, readonly) SlidePopContainerViewController *slidePopContainer;

@end
