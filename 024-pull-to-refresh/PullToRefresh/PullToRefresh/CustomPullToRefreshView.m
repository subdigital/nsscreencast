//
//  CustomPullToRefreshView.m
//  PullToRefresh
//
//  Created by Ben Scheirman on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomPullToRefreshView.h"

@interface CustomPullToRefreshView () {
    CGFloat _progress;
    UIColor *_barColor;
    UIActivityIndicatorView *_indicator;
}

@end

@implementation CustomPullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _barColor = [UIColor lightGrayColor];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setHidesWhenStopped:YES];
        [self addSubview:_indicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _indicator.center = CGPointMake(floorf(self.bounds.size.width / 2.0f), 
                                    floorf(self.bounds.size.height / 2.0f));
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, self.bounds);
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat barHeight = 10;
    CGFloat barWidth = (width / 2.0) * _progress;

    CGFloat barY = height - barHeight;
    
    CGRect leftRect = CGRectMake(0, barY, barWidth, barHeight);
    [_barColor set];
    CGContextFillRect(context, leftRect);
    
    CGFloat rightX = width - barWidth;
    CGRect rightRect = CGRectMake(rightX, barY, barWidth, barHeight);
    CGContextFillRect(context, rightRect);
}

/**
 The pull to refresh view's state has changed. The content view must update itself. All content view's must implement
 this method.
 */
- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
    switch (state) {
        case SSPullToRefreshViewStateNormal:
            _barColor = [UIColor lightGrayColor];
            break;
            
        case SSPullToRefreshViewStateLoading:
            [_indicator startAnimating];
            _barColor = [UIColor colorWithRed:.7 green:1.0 blue:.7 alpha:1.0];
            break;
            
        case SSPullToRefreshViewStateReady:
            _barColor = [UIColor greenColor];
            break;
            
        case SSPullToRefreshViewStateClosing:
            [_indicator stopAnimating];
            _barColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

- (void)setPullProgress:(CGFloat)pullProgress {
    _progress = pullProgress;
    [self setNeedsDisplay];
}

@end
