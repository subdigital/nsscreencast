//
//  Foo+Swizzling.m
//  SwizzleFun
//
//  Created by ben on 5/31/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "Foo+Swizzling.h"
#import "FKBSwizzler.h"

@implementation Foo (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FKBSwizzler swizzleClass:self
                         selector:@selector(bar)
                      newSelector:@selector(fkb_bar)];
    });
}

- (void)fkb_bar {
    NSLog(@"---- BAR Being called ---");
    [self fkb_bar];
    NSLog(@"---- BAR finished --- ");
}

@end
