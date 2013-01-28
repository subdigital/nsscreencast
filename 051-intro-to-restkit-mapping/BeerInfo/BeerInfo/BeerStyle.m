//
//  BeerStyle.m
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeerStyle.h"

@implementation BeerStyle

+ (RKMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BeerStyle class]];
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id": @"styleId",
        @"description": @"styleDescription",
        @"category.name": @"category"
     }];
    return mapping;
}

@end
