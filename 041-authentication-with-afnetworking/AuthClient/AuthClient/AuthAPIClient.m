//
//  AuthAPIClient.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "AuthAPIClient.h"
#import "CredentialStore.h"

#define BASE_URL @"http://nsscreencast-auth-server.herokuapp.com"

@implementation AuthAPIClient

+ (id)sharedClient {
    static AuthAPIClient *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
        __instance = [[AuthAPIClient alloc] initWithBaseURL:baseUrl];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
    }
    return self;
}

@end
