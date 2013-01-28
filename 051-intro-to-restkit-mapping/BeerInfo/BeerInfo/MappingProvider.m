//
//  MappingProvider.m
//  BeerInfo
//
//  Created by ben on 1/27/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "MappingProvider.h"
#import "Beer.h"
#import "BeerStyle.h"
#import "Brewery.h"

@implementation MappingProvider

+ (RKMapping *)beerStyleMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BeerStyle class]];
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"id": @"styleId",
     @"description": @"styleDescription",
     @"category.name": @"category"
     }];
    return mapping;
}

+ (RKMapping *)beerMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Beer class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"abv", @"ibu"]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"brewery.name": @"brewery",
     @"labels.icon": @"labelIconImageUrl"
     }];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"breweries"
                                             mapping:[MappingProvider breweryMapping]];
    return mapping;
}

+ (RKMapping *)breweryMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Brewery class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"website"]];
    return mapping;
}

@end
