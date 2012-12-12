//
//  MyIAPGateway.m
//  iap
//
//  Created by ben on 12/2/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "MyIAPGateway.h"

@implementation MyIAPGateway

+ (id)sharedGateway {
    static MyIAPGateway *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *productIds = [NSSet setWithObject:@"nsscreencast_iap_backstage"];
        __instance = [[MyIAPGateway alloc] initWithProductIdentifiers:productIds];
    });
    return __instance;
}

@end
