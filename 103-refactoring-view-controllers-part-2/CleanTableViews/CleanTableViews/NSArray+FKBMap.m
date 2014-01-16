//
//  NSArray+FKBMap.m
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "NSArray+FKBMap.h"

@implementation NSArray (FKBMap)

- (NSArray *)fkb_map:(id (^)(id inputItem))transformBlock {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id item in self) {
        id newItem = transformBlock(item);
        [newArray addObject:newItem];
    }
    
    return [NSArray arrayWithArray:newArray];
}

@end
