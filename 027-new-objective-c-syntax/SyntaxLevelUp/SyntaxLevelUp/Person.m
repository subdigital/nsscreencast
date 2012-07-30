//
//  Person.m
//  SyntaxLevelUp
//
//  Created by Ben Scheirman on 7/29/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end
