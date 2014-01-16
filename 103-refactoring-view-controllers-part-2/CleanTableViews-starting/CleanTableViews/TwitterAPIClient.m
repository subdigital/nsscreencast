//
//  TwitterAPIClient.m
//  CleanTableViews
//
//  Created by ben on 1/6/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "TwitterAPIClient.h"

@implementation TwitterAPIClient

- (NSURL *)followersURL {
    return [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
}

- (NSDictionary *)followerParams {
    return @{
             @"skip_status": @"1",
             @"count": @"500"
             };
}

- (SLRequest *)followersRequestForAccount:(ACAccount *)account {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:[self followersURL]
                                               parameters:[self followerParams]];
    request.account = account;
    return request;
}

- (void)fetchFollowersForAccount:(ACAccount *)account
                      completion:(void (^)(NSArray *followers, NSError *error))completion {
    SLRequest *request = [self followersRequestForAccount:account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            if ([self successfulStatusCode:urlResponse.statusCode]) {
                NSError *jsonError = nil;
                NSDictionary *followerData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (followerData) {
                        NSLog(@"Response: %@", followerData);
                        completion(followerData[@"users"], nil);
                    } else {
                        NSLog(@"JSON Parsing error: %@", jsonError);
                        completion(nil, jsonError);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Server returned HTTP %d", urlResponse.statusCode);
                    completion(nil, [NSError errorWithDomain:@"TwitterAPIClientDomain"
                                                        code:0
                                                    userInfo:@{ @"status": @(urlResponse.statusCode)}
                                     ]);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Something went wrong: %@", [error localizedDescription]);
                completion(nil, [NSError errorWithDomain:@"TwitterAPIClientDomain"
                                                    code:1
                                                userInfo:@{}
                                 ]);
            });
        }
    }];
}

- (BOOL)successfulStatusCode:(NSInteger)statusCode {
    return statusCode >= 200 && statusCode < 300;
}

@end
