//
//  Converter.m
//  CocoaBindings
//
//  Created by Ben Scheirman on 1/13/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

#import "Converter.h"

@implementation Converter

+ (NSSet *)keyPathsForValuesAffectingCelsius {
    return [NSSet setWithObject:@"fahrenheit"];
}

- (CGFloat)celsius {
    return (self.fahrenheit - 32) / 1.8;
}

- (void)setCelsius:(CGFloat)celsius {
    self.fahrenheit = (celsius * 1.8) + 32;
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"celsius"] || [key isEqualToString:@"fahrenheit"]) {
        [self setValue:@0 forKey:key];
    } else {
        [super setNilValueForKey:key];
    }
}

@end
