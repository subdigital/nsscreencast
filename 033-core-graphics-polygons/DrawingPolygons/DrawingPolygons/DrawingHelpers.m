//
//  DrawingHelpers.m
//  FunWithGradients
//
//  Created by Ben Scheirman on 9/3/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "DrawingHelpers.h"

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[ (__bridge id)(startColor), (__bridge id)endColor ];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);

    CGContextAddRect(context, rect);
    CGContextClip(context);

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CFRelease(gradient);
    CFRelease(colorSpace);
}

void drawGlossyGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    drawLinearGradient(context, rect, startColor, endColor);
    
    CGColorRef shineStart = [[UIColor colorWithWhite:0.9 alpha:0.35] CGColor];
    CGColorRef shineEnd = [[UIColor colorWithWhite:0.9 alpha:0.1] CGColor];
    CGRect shineRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / 2.0f);
    drawLinearGradient(context, shineRect, shineStart, shineEnd);
}