//
//  NSArray+CollectionAdditions.h
//  ImgShare
//
//  Created by Ben Scheirman on 11/3/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CollectionAdditions)

- (NSArray *)img_map:(id (^)(id object))transform;
- (NSArray *)img_select:(BOOL (^)(id object))filter;

@end
