//
//  PlaylistHeaderView.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/16/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "PlaylistHeaderView.h"

@implementation PlaylistHeaderView

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
