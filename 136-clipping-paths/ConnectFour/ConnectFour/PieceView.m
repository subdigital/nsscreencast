//
//  PieceView.m
//  ConnectFour
//
//  Created by Ben Scheirman on 8/29/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "PieceView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PieceView

- (id)initWithFrame:(CGRect)frame pieceColor:(PieceColor)pieceColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = frame.size.width / 2.0f;
    }
    return self;
}

@end
