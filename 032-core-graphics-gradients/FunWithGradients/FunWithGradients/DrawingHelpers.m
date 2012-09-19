//
//  DrawingHelpers.m
//  FunWithGradients
//
//  Created by Ben Scheirman on 9/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "DrawingHelpers.h"

void drawLinearGradient(CGContextRef context, CGColorRef color1, CGColorRef color2, CGRect rect) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[ (__bridge id)color1, (__bridge id)color2 ];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
//    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:1.0] CGColor]);
//    CGContextSetLineWidth(context, 2);
//    CGContextStrokeRect(context, rect);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CFRelease(gradient);
    CFRelease(colorSpace);
}

void drawGlossyGradient(CGContextRef context, CGColorRef color1, CGColorRef color2, CGRect rect) {
    drawLinearGradient(context, color1, color2, rect);
    
    CGColorRef shineStartColor = CGColorRetain([[UIColor colorWithWhite:1.0 alpha:0.05] CGColor]);
    CGColorRef shineEndColor   = CGColorRetain([[UIColor colorWithWhite:1.0 alpha:0.6] CGColor]);
    
    CGRect shineRect = CGRectMake(CGRectGetMinX(rect),
                                  CGRectGetMinY(rect),
                                  CGRectGetWidth(rect),
                                  floorf(CGRectGetHeight(rect) / 2.0));
    
    drawLinearGradient(context, shineStartColor, shineEndColor, shineRect);

    CGColorRelease(shineStartColor);
    CGColorRelease(shineEndColor);
}