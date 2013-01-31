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

- (NSString *)brewery {
    if ([self.breweries count] > 0) {
        return [self.breweries[0] name];
    }
    
    return nil;
}

@end
