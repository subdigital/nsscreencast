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
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"BeerStyle"
                                                   inManagedObjectStore:[[BeerInfoDataModel sharedDataModel] objectStore]];
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id": @"styleId",
        @"description": @"styleDescription",
        @"category.name": @"category"
     }];
    return mapping;
}

+ (RKMapping *)beerMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Beer"
                                                   inManagedObjectStore:[[BeerInfoDataModel sharedDataModel] objectStore]];
    
    [mapping addAttributeMappingsFromArray:@[@"name", @"ibu", @"abv"]];
    [mapping addAttributeMappingsFromDictionary:@{@"labels.icon": @"labelIconImageUrl"}];
    [mapping addRelationshipMappingWithSourceKeyPath:@"breweries"
                                             mapping:[MappingProvider breweryMapping]];
    return mapping;
}

+ (RKMapping *)breweryMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Brewery"
                                                   inManagedObjectStore:[[BeerInfoDataModel sharedDataModel] objectStore]];

                                
    [mapping addAttributeMappingsFromArray:@[@"name", @"website"]];
    return mapping;
}

@end
