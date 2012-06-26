//
//  CustomTabBar.m
//  CustomizingNavigationBar
//
//  Created by Ben Scheirman on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

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
    UIImage *tabbarBg = [UIImage imageNamed:@"tabbar-background.png"];
    UIImage *tabBarSelected = [UIImage imageNamed:@"tabbar-background-pressed.png"];
    [self setBackgroundImage:tabbarBg];
    [self setSelectionIndicatorImage:tabBarSelected];
}

@end
