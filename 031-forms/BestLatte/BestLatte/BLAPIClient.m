//
//  BLAPIClient.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLAPIClient.h"

#define BASE_URL @"http://best-latte.herokuapp.com"

@implementation BLAPIClient

+ (id)sharedClient {
    static BLAPIClient *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:BASE_URL];
        __instance = [[BLAPIClient alloc] initWithBaseURL:url];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

@end
