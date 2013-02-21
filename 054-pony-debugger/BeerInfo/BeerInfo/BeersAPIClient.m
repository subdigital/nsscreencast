//
//  BeersAPIClient.m
//  BeerInfo
//
//  Created by ben on 2/5/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeersAPIClient.h"

@implementation BeersAPIClient


+ (BeersAPIClient *)sharedClient {
    static BeersAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://api.brewerydb.com/v2"];
        _sharedClient = [[BeersAPIClient alloc] initWithBaseURL:baseURL];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:parameters];
    params[@"key"] = BREWERY_DB_API_KEY;
    return [super requestWithMethod:method
                               path:path
                         parameters:params];
}

@end