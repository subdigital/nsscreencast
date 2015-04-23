//
//  UIButton+BackgroundColorForState.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 4/19/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "UIButton+BackgroundColorForState.h"

@implementation UIButton (BackgroundColorForState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    view.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:image forState:state];
}

@end
