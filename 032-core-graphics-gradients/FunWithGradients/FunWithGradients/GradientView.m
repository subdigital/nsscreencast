//
//  GradientView.m
//  FunWithGradients
//
//  Created by Ben Scheirman on 9/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "GradientView.h"
#import "DrawingHelpers.h"

@implementation GradientView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    drawLinearGradient(context, [[UIColor redColor] CGColor], [[UIColor blueColor] CGColor], self.bounds);
    
    CGRect buttonRect = CGRectMake(100, 200, 150, 80);
    drawGlossyGradient(context, [[UIColor colorWithRed:0.1 green:0.1 blue:0.8 alpha:1.0] CGColor],
                       [[UIColor colorWithRed:0.4 green:0.5 blue:0.9 alpha:1.0] CGColor], buttonRect);
}


@end
