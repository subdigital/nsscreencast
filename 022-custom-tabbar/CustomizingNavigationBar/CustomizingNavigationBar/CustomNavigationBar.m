//
//  CustomNavigationBar.m
//  CustomizingNavigationBar
//
//  Created by Ben Scheirman on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

+ (void)initialize {
    const CGFloat ArrowLeftCap = 14.0f;
    UIImage *back = [UIImage imageNamed:@"nav-backbutton.png"];
    back = [back stretchableImageWithLeftCapWidth:ArrowLeftCap
                                     topCapHeight:0];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[CustomNavigationBar class], nil] setBackButtonBackgroundImage:back
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    const CGFloat TextOffset = 3.0f;
    [[UIBarButtonItem appearanceWhenContainedIn:[CustomNavigationBar class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(TextOffset, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}

- (void)customize {
    UIImage *navBarBg = [UIImage imageNamed:@"navigationbar.png"];
    [self setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
}


@end
