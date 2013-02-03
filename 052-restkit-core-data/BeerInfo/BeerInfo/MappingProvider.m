//
//  MappingProvider.m
//  BeerInfo
//
//  Created by ben on 1/29/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "MappingProvider.h"
#import "BeerStyle.h"
#import "Beer.h"
#import "Brewery.h"
#import "BeerInfoDataModel.h"

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
    
    [mapping addAttributeMappingsFromArray:@[@"name", @"ibu", @"abv"]];
    [mapping addAttributeMappingsFromDictionary:@{@"labels.icon": @"labelIconImageUrl"}];
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
