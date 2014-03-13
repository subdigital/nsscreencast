//
//  PhoneNumber.m
//  Xcode51
//
//  Created by ben on 3/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "PhoneNumber.h"
@import CoreLocation;

@implementation PhoneNumber

- (id)initWithString:(NSString *)phoneNumberString  {
    self = [super init];
    if (self) {
        [self parseNumberIntoParts:phoneNumberString];
    }
    
    return self;
}

- (void)parseNumberIntoParts:(NSString *)input {
    self.areaCode = [input substringToIndex:3];
    self.prefix = [input substringWithRange:NSMakeRange(3, 3)];
    self.suffix = [input substringWithRange:NSMakeRange(6, 4)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@) %@-%@", self.areaCode, self.prefix, self.suffix];
}

- (id)debugQuickLookObject {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:29.7628
                                                      longitude:-95.3831];
    return location;
}

@end
