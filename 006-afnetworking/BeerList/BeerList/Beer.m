//
//  Beer.m
//  BeerList
//
//  Created by Ben Scheirman on 2/26/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "Beer.h"

@implementation Beer

@synthesize name = _name;
@synthesize brewery = _brewery;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.brewery = [dictionary objectForKey:@"brewery_name"];
    }
    
    return self;
}

- (void)dealloc {
    [_name release];
    [_brewery release];
    [super dealloc];
}

@end
