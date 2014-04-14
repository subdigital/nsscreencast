//
//  PolygonView.m
//  DrawingPolygons
//
//  Created by Ben Scheirman on 9/9/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "PolygonView.h"
#import "DrawingHelpers.h"

#define MIN_NUM_SIDES 3
#define MAX_NUM_SIDES 100

@implementation PolygonView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.numberOfSides = MIN_NUM_SIDES;
    self.fillColor = [UIColor redColor];
    self.strokeColor = [UIColor whiteColor];
}

- (void)setNumberOfSides:(NSUInteger)numberOfSides {
    if (numberOfSides < MIN_NUM_SIDES) {
        numberOfSides = MIN_NUM_SIDES;
    }
    
    if (numberOfSides > MAX_NUM_SIDES) {
        numberOfSides = MAX_NUM_SIDES;
    }
    
    _numberOfSides = numberOfSides;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.numberOfSides == 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = floorf( 0.9 * MIN(self.bounds.size.width, self.bounds.size.height) / 2.0f );
    
    CGContextSetFillColorWithColor(context, [self.fillColor CGColor]);
    CGContextSetStrokeColorWithColor(context, [self.strokeColor CGColor]);
    CGContextSetLineWidth(context, 6.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat startingAngle = 2 * M_PI / self.numberOfSides / 2.0f;
    for (int n = 0; n < self.numberOfSides; n++) {
        CGFloat rotationFactor = ((2 * M_PI) / self.numberOfSides) * (n+1) + startingAngle;
        CGFloat x = (self.bounds.size.width / 2.0f) + cos(rotationFactor) * radius;
        CGFloat y = (self.bounds.size.height / 2.0f) + sin(rotationFactor) * radius;
        
        if (n == 0) {
            CGPathMoveToPoint(path, NULL, x, y);
        } else {
            CGPathAddLineToPoint(path, NULL, x, y);
        }
    }
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, CGSizeMake(0, 10), 2.0);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    drawLinearGradient(context, self.bounds, [self.fillColor CGColor], [[UIColor blueColor] CGColor]);
    
    CGContextRestoreGState(context);
    
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    
    
    CFRelease(path);
}

@end





