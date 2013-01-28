//
//  Brewery.m
//  BeerInfo
//
//  Created by ben on 1/27/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "Brewery.h"

@implementation Brewery

+ (RKMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Brewery class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"website"]];
    return mapping;
}

@end
