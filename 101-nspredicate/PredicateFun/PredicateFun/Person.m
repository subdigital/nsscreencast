//
//  Person.m
//  PredicateFun
//
//  Created by ben on 12/31/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "Person.h"

@implementation Person
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ (%@) - %@, %@  %@", self.firstName, self.lastName, self.age, self.address.city, self.address.state, self.address.zip];
}
@end
