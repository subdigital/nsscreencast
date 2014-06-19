//
//  UIViewController+Analytics.m
//  SwizzleFun
//
//  Created by ben on 5/31/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "UIViewController+Analytics.h"
#import "FKBSwizzler.h"

@implementation UIViewController (Analytics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FKBSwizzler swizzleClass:self
                         selector:@selector(viewDidAppear:)
                      newSelector:@selector(fkb_viewDidAppear:)];
    });
}

- (void)fkb_viewDidAppear:(BOOL)animated {
    [self fkb_viewDidAppear:animated];
    NSLog(@"viewDidAppear: called on %@ (animated? %@)",
          self.title ?: self.class,
          animated ? @"YES" : @"NO"
          );
}

@end
