//
//  TapScrollView.m
//  SwipeToRevealCell
//
//  Created by ben on 2/27/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "BSTapScrollView.h"

@implementation BSTapScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch on scroll view ended");
    if (!self.dragging) {
        NSLog(@"Next responder: %@", self.nextResponder);
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end
