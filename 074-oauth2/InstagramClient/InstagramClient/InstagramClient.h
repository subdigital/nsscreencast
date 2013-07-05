//
//  InstagramClient.h
//  InstagramClient
//
//  Created by ben on 6/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "AFNetworking.h"
#import "AFHTTPClient.h"

@interface InstagramClient : AFHTTPClient

+ (instancetype)sharedClient;

- (void)authenticateWithClientID:(NSString *)clientId callbackURL:(NSString *)callbackUrl;
- (void)handleOAuthCallbackWithURL:(NSURL *)url;

@end
