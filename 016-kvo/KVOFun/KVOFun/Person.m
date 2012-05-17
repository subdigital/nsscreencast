//
//  Person.m
//  KVOFun
//
//  Created by Ben Scheirman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name = _name;

- (id)init {
    self = [super init];
    if (self) {
        _name = @"Henry";
    }
    
    return self;
}

@end
