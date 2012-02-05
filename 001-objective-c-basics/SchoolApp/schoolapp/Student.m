//
//  Student.m
//  SchoolApp
//
//  Created by Ben Scheirman on 2/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "Student.h"

@implementation Student

@synthesize name = _name;

- (NSString *)description {
    return self.name;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

@end
