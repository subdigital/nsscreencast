//
//  PlaylistHeaderView.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/16/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "PlaylistHeaderView.h"

@interface PlaylistHeaderView ()

@property (nonatomic, strong) UIView *progressView;

@end

@implementation PlaylistHeaderView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.progressView) {
        self.progressView = [[UIView alloc] init];
        self.progressView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.progressView];
    }
    
    const CGFloat ProgressBarHeight = 2;
    CGFloat x = 0;
    CGFloat y = self.bounds.size.height - ProgressBarHeight;
    CGFloat w = self.bounds.size.width * self.progress;
    CGFloat h = ProgressBarHeight;
    
    self.progressView.frame = CGRectMake(x, y, w, h);
}

- (void)setPlaylistItem:(id<PlaylistItem>)playlistItem animated:(BOOL)animated {
    void (^updateBlock)() = ^ {
        self.artistLabel.text = [playlistItem artist];
        self.songLabel.text = [playlistItem title];
        self.blurredImageView.image = [playlistItem image];
        self.imageView.image = [playlistItem image];
    };
    
    if (animated) {
        
        UIView *prevState = [self snapshotViewAfterScreenUpdates:NO];
        [self addSubview:prevState];
        updateBlock();
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             prevState.alpha = 0;
                         } completion:^(BOOL finished) {
                             [prevState removeFromSuperview];
                         }];
        
    } else {
        updateBlock();
    }
}

@end
