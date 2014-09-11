//
//  GameBoardView.m
//  ConnectFour
//
//  Created by Ben Scheirman on 8/16/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "GameBoardView.h"

#define PADDING 8.0

@interface GameBoardView ()

@end

@implementation GameBoardView

- (id)initWithRows:(NSInteger)rows columns:(NSInteger)columns {
    self = [super init];
    if (self) {
        self.rows = rows;
        self.columns = columns;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.opaque = NO;
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    CGFloat aspectRatio = self.columns / (CGFloat)self.rows;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1/aspectRatio
                                                      constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[self(>=200)]"
                                                                options:0
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(self)]];
}

- (CGSize)pieceSize {
    CGRect innerRect = CGRectInset(self.bounds, PADDING, PADDING);
    CGFloat squareSize = innerRect.size.width / self.columns;
    return CGSizeMake(squareSize, squareSize);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);
    CGContextAddRect(context, self.bounds);
    
    CGRect innerRect = CGRectInset(self.bounds, PADDING, PADDING);
    CGFloat squareSize = innerRect.size.width / self.columns;
    CGContextTranslateCTM(context, PADDING, PADDING);
    for (int y = 0; y < self.rows; y++) {
        for (int x = 0; x < self.columns; x++) {
            CGFloat holeSize = squareSize - PADDING * 2;
            CGRect holeRect = CGRectMake(PADDING, PADDING, holeSize, holeSize);
            CGContextAddEllipseInRect(context, holeRect);
            CGContextTranslateCTM(context, squareSize, 0);
        }
        CGContextTranslateCTM(context, - innerRect.size.width, squareSize);
    }
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.822 green:0.822 blue:0.000 alpha:1.000].CGColor);
    CGContextEOFillPath(context);
    
    CGContextRestoreGState(context);
}

@end
