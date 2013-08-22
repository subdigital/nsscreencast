//
//  UIButton+Blocks.m
//  BlockButton
//
//  Created by ben on 8/20/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "UIButton+Blocks.h"
#import <objc/runtime.h>

static char BlockKey;

@implementation UIButton (Blocks)

- (void)addTargetWithBlock:(ButtonBlock)block {
    objc_setAssociatedObject(self, &BlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(executeBlock)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)executeBlock {
    ButtonBlock block = objc_getAssociatedObject(self, &BlockKey);
    if (block) {
        block();
    }
}

@end
