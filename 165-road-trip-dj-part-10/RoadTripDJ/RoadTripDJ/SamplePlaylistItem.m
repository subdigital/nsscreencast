//
//  SamplePlaylistItem.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/11/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "SamplePlaylistItem.h"


@implementation SamplePlaylistItem

- (instancetype)initWithImage:(UIImage *)image artist:(NSString *)artist title:(NSString *)title {
    self = [super init];
    if (self) {
        _image = image;
        _artist = artist;
        _title = title;
    }
    return self;
}

@end
