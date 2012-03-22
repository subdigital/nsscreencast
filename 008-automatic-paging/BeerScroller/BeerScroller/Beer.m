//
//  Beer.m
//  BeerScroller
//
//  Created by Ben Scheirman on 3/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "Beer.h"

@implementation Beer

@synthesize beerId = _beerId;
@synthesize name = _name;
@synthesize brewery = _brewery;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.beerId = [[dictionary objectForKey:@"id"] intValue];
        self.name = [dictionary objectForKey:@"name"];
        self.brewery = [dictionary objectForKey:@"brewery_name"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Beer class]]) {
        return NO;
    }
    
    Beer *other = (Beer *)object;
    return other.beerId == self.beerId;
}

- (void)dealloc {
    [_name release];
    [_brewery release];
    
    [super dealloc];
}

@end
