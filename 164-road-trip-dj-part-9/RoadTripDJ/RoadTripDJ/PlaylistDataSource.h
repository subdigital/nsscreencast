//
//  PlaylistDataSource.h
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/11/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistItem.h"
#import "PlaylistHeaderView.h"

@interface PlaylistDataSource : NSObject <UICollectionViewDataSource>


@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger currentTrackIndex;
@property (nonatomic, strong) PlaylistHeaderView *playlistHeaderView;

@end
