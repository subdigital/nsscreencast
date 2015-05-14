//
//  MPMediaItem+PlaylistItem.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 4/15/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "MPMediaItem+PlaylistItem.h"

@implementation MPMediaItem (PlaylistItem)

- (UIImage *)image {
    return [self.artwork imageWithSize:CGSizeMake(600, 600)];
}

@end
