//
//  PlaylistHeaderView.h
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/16/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistItem.h"

@interface PlaylistHeaderView : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UIImageView *blurredImageView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *songLabel;

- (void)setPlaylistItem:(id<PlaylistItem>)playlistItem animated:(BOOL)animated;

@end
