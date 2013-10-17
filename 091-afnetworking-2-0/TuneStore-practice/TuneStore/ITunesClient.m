//
//  ITunesClient.m
//  TuneStore
//
//  Created by ben on 10/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ITunesClient.h"

@implementation ITunesClient

+ (ITunesClient *)sharedClient {
    static ITunesClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        [config setURLCache:cache];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0" }];
        
        NSURL *baseURL = [NSURL URLWithString:@"https://itunes.apple.com"];
        
        _sharedClient = [[ITunesClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)searchForTerm:(NSString *)term completion:( void (^)(NSArray *results, NSError *error) )completion {
    NSString *termEncoded = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    id params = @{ @"term" : termEncoded,
                   @"country" : @"US" };
    return [self GET:@"https://itunes.apple.com/search"
          parameters:params
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 if (responseObject) {
                     completion(responseObject[@"results"], nil);
                 } else {
                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                     NSLog(@"Received HTTP %d", httpResponse.statusCode);
                     completion(nil, nil);
                 }
                     
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 NSLog(@"ERROR: %@", error);
                 completion(nil, error);
             }];
}

@end
