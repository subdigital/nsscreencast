//
//  NSArray+FKBMap.h
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FKBMap)

- (NSArray *)fkb_map:(id (^)(id inputItem))transformBlock;

@end
