//
//  DrawingHelpers.h
//  FunWithGradients
//
//  Created by Ben Scheirman on 9/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGColorRef color1, CGColorRef color2, CGRect rect);
void drawGlossyGradient(CGContextRef context, CGColorRef color1, CGColorRef color2, CGRect rect);