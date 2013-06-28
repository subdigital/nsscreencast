//
//  BeersAPIClient.m
//  PinningDemo
//
//  Created by ben on 6/23/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "BeersAPIClient.h"

@implementation BeersAPIClient

+ (BeersAPIClient *)sharedClient {
    static BeersAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://beerapi.heroku.com"];
        _sharedClient = [[BeersAPIClient alloc] initWithBaseURL:baseURL];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"x-api-token" value:@"1234abcd"];
    }
    return self;
}

-(AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSMutableURLRequest *req = [urlRequest mutableCopy];
    [req addValue:@"" forHTTPHeaderField:@"If-None-Match"];
    AFHTTPRequestOperation *op = [super HTTPRequestOperationWithRequest:req success:success failure:failure];
    op.SSLPinningMode = AFSSLPinningModePublicKey;
    return op;
}

@end
