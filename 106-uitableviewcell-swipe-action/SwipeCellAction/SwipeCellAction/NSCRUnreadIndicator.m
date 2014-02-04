//
//  NSCRUnreadIndicator.m
//  nsscreencast-ios
//
//  Created by Ben Scheirman on 2/2/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "NSCRUnreadIndicator.h"

@interface NSCRUnreadIndicator () {
    CGFloat _fillPercent;
}

@end

@implementation NSCRUnreadIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.clipsToBounds = NO;
        _fillPercent = 1;
        _hasRead = NO;
    }
    return self;
}

- (void)setHasRead:(BOOL)hasRead {
    _hasRead = hasRead;
    [self setNeedsDisplay];
}

- (void)setFillPercent:(CGFloat)percent {
    _fillPercent = MAX(0, MIN(percent, 1.0));
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    
    CGRect dotRect = CGRectInset(self.bounds, 2, 2);
    
    CGFloat insetAmount = 12 - (_fillPercent * 10);
    CGRect fillRect = CGRectInset(self.bounds, insetAmount, insetAmount);
    
    if (self.hasRead) {
        CGMutablePathRef clipPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(clipPath, NULL, fillRect);
        CGPathAddEllipseInRect(clipPath, NULL, dotRect);
        CGContextAddPath(context, clipPath);
        CGContextEOFillPath(context);
    } else {
        CGContextFillEllipseInRect(context, fillRect);
    }
    
    CGContextRestoreGState(context);
}


@end
