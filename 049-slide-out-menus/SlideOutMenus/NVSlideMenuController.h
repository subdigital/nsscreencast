//
//  NVSlideMenuViewController.h
//  NVSlideMenuViewControllerDemo
//
//  Created by Nicolas Verinaud on 31/12/12.
//  Copyright (c) 2012 Nicolas Verinaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NVSlideMenuController : UIViewController

@property (nonatomic, readonly, strong) UIViewController *menuViewController;
@property (nonatomic, readonly, strong) UIViewController *contentViewController;
@property (nonatomic, assign) BOOL panEnabledWhenSlideMenuIsHidden; // When the menu is hidden, does the pan gesture trigger ? Default is YES.

- (id)initWithMenuViewController:(UIViewController *)menuViewController andContentViewController:(UIViewController *)contentViewController;

/** @name Navigation */
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)showContentViewControllerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (IBAction)toggleMenuAnimated:(id)sender; // Convenience for use with target/action, always animate
- (void)showMenuAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

/** @name Menu state information */
- (BOOL)isMenuOpen;

@end


@interface UIViewController (NVSlideMenuController)

@property (nonatomic, readonly) NVSlideMenuController *slideMenuController;

@end
