//
//  Episode.h
//  MantleDemo
//
//  Created by Ben Scheirman on 4/19/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef NS_ENUM(NSInteger, EpisodeType) {
    EpisodeTypePaid,
    EpisodeTypeFree
};

@interface Episode : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, assign) NSInteger episodeNumber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *episodeDescription;
@property (nonatomic, copy) NSURL *thumbnailImageUrl;
@property (nonatomic, assign) EpisodeType episodeType;
@property (nonatomic, strong) NSDate *publishedAt;

@end
