//
//  FKBSwizzler.m
//  SwizzleFun
//
//  Created by ben on 5/31/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "FKBSwizzler.h"
#import <objc/runtime.h>

@implementation FKBSwizzler

+ (void)swizzleClass:(Class)class selector:(SEL)originalSelector newSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL methodAdded = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (methodAdded) {
        class_addMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end
