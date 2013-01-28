//
//  Beer.m
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "Beer.h"
#import "Brewery.h"

@implementation Beer

+ (RKMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Beer class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"abv", @"ibu"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"brewery.name": @"brewery",
        @"labels.icon": @"labelIconImageUrl"
     }];
    [mapping addRelationshipMappingWithSourceKeyPath:@"breweries"
                                             mapping:[Brewery mapping]];
    return mapping;
}

- (NSString *)brewery {
    if ([self.breweries count] > 0) {
        return [self.breweries[0] name];
    }
    
    return nil;
}

@end
