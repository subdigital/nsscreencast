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
            @"episodeType": @"episode_type",
            @"publishedAt": @"published_at",
            @"episodeNumber" : @"episode_number",
            @"thumbnailImageUrl": @"thumbnail_url"
        };
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

+ (NSValueTransformer *)episodeTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                    @"free": @(EpisodeTypeFree),
                                                                    @"paid": @(EpisodeTypePaid)
                                                                    }];
}

+ (NSValueTransformer *)thumbnailUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)publishedAtJSONTransformer {
    NSDateFormatter *dateFormatter = self.dateFormatter;
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        return [dateFormatter dateFromString:dateString];
    }];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Episode";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{ };
}

+ (NSValueTransformer *)thumbnailImageUrlEntityAttributeTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSString *(NSURL *url) {
        return [url description];
    } reverseBlock:^NSURL *(NSString *urlString) {
        return [NSURL URLWithString:urlString];
    }];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"episodeNumber"];
}

@end
