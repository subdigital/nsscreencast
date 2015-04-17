//
//  SamplePlaylistItem.h
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/11/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistItem.h"

@interface SamplePlaylistItem : NSObject <PlaylistItem>

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *artist;
@property (nonatomic, readonly) NSString *title;

- (instancetype)initWithImage:(UIImage *)image artist:(NSString *)artist title:(NSString *)song;

@end
