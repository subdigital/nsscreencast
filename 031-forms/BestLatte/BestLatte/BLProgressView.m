//
//  BLProgressView.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface BLProgressView ()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BLProgressView

@synthesize progressView = _progressView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.layer.shadowColor  = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectInset(self.bounds, 30.0f, 10.0f);
        
        [self addSubview:self.progressView];
    }
    return self;
}

+ (id)presentInWindow:(UIWindow *)window {
    CGRect rect = CGRectMake(0, 0, window.frame.size.width, 40.0f);
    
    // position just off screen
    rect.origin.y = window.frame.size.height;
    BLProgressView *pv = [[BLProgressView alloc] initWithFrame:rect];
    [window addSubview:pv];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect finalRect = rect;
        finalRect.origin.y -= pv.frame.size.height;
        pv.frame = finalRect;
    }];
    
    return pv;
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        
        // position just off screen & account for shadow
        rect.origin.y += self.frame.size.height + 10;
        
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setProgress:(CGFloat)progress {
    self.progressView.progress = progress;
}

@end
