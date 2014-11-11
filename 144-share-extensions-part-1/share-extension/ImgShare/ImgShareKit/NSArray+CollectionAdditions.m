//
//  NSArray+CollectionAdditions.m
//  ImgShare
//
//  Created by Ben Scheirman on 11/3/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "NSArray+CollectionAdditions.h"

@implementation NSArray (CollectionAdditions)

- (NSArray *)img_map:(id (^)(id object))transform {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        [array addObject:transform(object)];
    }
    return [array copy];
}

- (NSArray *)img_select:(BOOL (^)(id))filter {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        if (filter(object)) {
            [array addObject:object];
        }
    }
    return [array copy];
}

@end
