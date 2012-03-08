//
//  BeersApiClient.m
//  BeerList
//
//  Created by Ben Scheirman on 2/26/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "BeersApiClient.h"
#import "AFNetworking.h"

#define BeersAPIBaseURLString @"http://localhost:3000/"
#define BeersAPIToken @"1234abcd"

@implementation BeersApiClient

+ (id)sharedInstance {
    static BeersApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[BeersApiClient alloc] initWithBaseURL:[NSURL URLWithString:BeersAPIBaseURLString]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"x-api-token" value:BeersAPIToken];
        
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

@end
