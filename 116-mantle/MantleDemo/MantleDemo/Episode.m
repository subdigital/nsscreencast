//
//  Episode.m
//  MantleDemo
//
//  Created by Ben Scheirman on 4/19/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "Episode.h"

@implementation Episode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"episodeDescription": @"description",
             @"episodeNumber" : @"episode_number",
             @"episodeType" : @"episode_type",
             @"publishedAt" : @"published_at",
             @"thumbnailImageUrl" : @"thumbnail_url"
             };
}

+ (NSValueTransformer *)episodeTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"paid": @(EpisodeTypePaid),
                                                                           @"free": @(EpisodeTypeFree)
                                                                           }];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        __dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return __dateFormatter;
}

+ (NSValueTransformer *)publishedAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)thumbnailImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
