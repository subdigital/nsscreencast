//
//  GradientView.m
//  DrawingPolygons
//
//  Created by Ben Scheirman on 9/9/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "GradientView.h"
#import "DrawingHelpers.h"

@implementation GradientView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color1 = [[UIColor colorWithWhite:0.35 alpha:1.0f] CGColor];
    CGColorRef color2 = [[UIColor colorWithWhite:0.15 alpha:1.0f] CGColor];
    drawLinearGradient(context, self.bounds, color1, color2);
}

@end
