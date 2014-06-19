//
//  FKBSwizzler.h
//  SwizzleFun
//
//  Created by ben on 5/31/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKBSwizzler : NSObject

+ (void)swizzleClass:(Class)class selector:(SEL)originalSelector newSelector:(SEL)newSelector;

@end
