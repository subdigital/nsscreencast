//
//  Beer.m
//  BeerInfo
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "Beer.h"
#import "BeerStyle.h"
#import "Brewery.h"

@implementation Beer

// @dynamic abv, ibu, labelIconImageUrl, name, breweries, style;

- (NSString *)brewery {
    return [[self.breweries objectAtIndex:0] name];
}

@end
