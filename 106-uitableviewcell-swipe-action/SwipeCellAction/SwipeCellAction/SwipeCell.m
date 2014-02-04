//
// Created by Ben Scheirman on 2/3/14.
// Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "SwipeCell.h"

@interface SwipeCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL hasChangedUnreadStatus;

@end

@implementation SwipeCell {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.contentSize = self.contentView.frame.size;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        
        [self.contentView insertSubview:_scrollView atIndex:0];
    }
    
    [self.scrollView addSubview:self.textLabel];
    
    if (_unreadIndicator == nil) {
        _unreadIndicator = [[NSCRUnreadIndicator alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [self.contentView addSubview:_unreadIndicator];
    }
    
    
    CGRect frame = self.unreadIndicator.frame;
    frame.origin.x = self.contentView.frame.size.width - self.unreadIndicator.frame.size.width - 10;
    frame.origin.y = (self.contentView.frame.size.height - self.unreadIndicator.frame.size.height) / 2.0;
    self.unreadIndicator.frame = frame;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    
    if (!self.hasChangedUnreadStatus) {
        const CGFloat MaxDistance = 40;
        CGFloat progress = MIN(1, scrollView.contentOffset.x / MaxDistance);
        [self.unreadIndicator setFillPercent:progress];
        
        if (progress >= 1.0) {
            self.unreadIndicator.hasRead = !self.unreadIndicator.hasRead;
            [self.unreadIndicator setFillPercent:0];
            self.hasChangedUnreadStatus = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.hasChangedUnreadStatus = NO;
}

@end