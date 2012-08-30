//
//  NSDictionary+JSONValueParsing.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/28/12.
//
//

#import "NSDictionary+JSONValueParsing.h"

@implementation NSDictionary (JSONValueParsing)

- (int)intForKey:(id)key {
    return [[self objectForKey:key] intValue];
}

- (NSString *)stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

@end
