//
//  DrawingHelpers.h
//  FunWithGradients
//
//  Created by Ben Scheirman on 9/3/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawGlossyGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);