//
//  MyIAPGateway.m
//  iap
//
//  Created by Ben Scheirman on 12/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "MyIAPGateway.h"

@implementation MyIAPGateway

+ (id)sharedGateway {
    static MyIAPGateway *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *products = [NSSet setWithObject:@"com.nsscreencast.iap.backstage_pass"];
        __instance = [[MyIAPGateway alloc] initWithProductIds:products];
    });
    return __instance;
}

@end
