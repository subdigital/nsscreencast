//
//  FaceView.m
//  CoreImageFun
//
//  Created by ben on 11/17/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scale = 1.0f;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.feature) {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextStrokeRect(context, self.bounds);
        
        CGRect faceRect = self.feature.bounds;
        CGContextScaleCTM(context, self.scale, self.scale);
        CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
        CGContextSetLineWidth(context, 3);
        CGContextStrokeRect(context, faceRect);
        
        if ([self.feature hasLeftEyePosition]) {
            [self drawEyeAtPosition:self.feature.leftEyePosition inContext:context];
        }
        
        if ([self.feature hasRightEyePosition]) {
            [self drawEyeAtPosition:self.feature.rightEyePosition inContext:context];
        }
        
        if ([self.feature hasMouthPosition]) {
            [self drawMouthAtPosition:self.feature.mouthPosition inContext:context];
        }
    }
}

- (void)drawMouthAtPosition:(CGPoint)position inContext:(CGContextRef)context {
    position = CGPointMake(position.x, self.imageSize.height - position.y);
    CGContextSaveGState(context);
    
    CGSize mouthSize = CGSizeMake(self.feature.bounds.size.width / 3,
                                  self.feature.bounds.size.height / 8);
    CGRect mouthRect = CGRectMake(roundf(position.x - mouthSize.width / 2),
                                  roundf(position.y - mouthSize.height / 2),
                                  roundf(mouthSize.width),
                                  roundf(mouthSize.height));
    
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextFillEllipseInRect(context, mouthRect);
    
    CGContextRestoreGState(context);
}

- (void)drawEyeAtPosition:(CGPoint)position inContext:(CGContextRef)context {
    position = CGPointMake(position.x, self.imageSize.height - position.y);
    
    CGContextSaveGState(context);
    
    const CGFloat SIZE = 20;
    
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    
    CGRect eyeRect = CGRectMake(position.x - SIZE/2, position.y - SIZE/2, SIZE, SIZE);
    CGContextFillEllipseInRect(context, eyeRect);
    
    CGContextRestoreGState(context);
}

@end
