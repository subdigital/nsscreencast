//
//  AuthAPIClient.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "AFNetworking.h"

@interface AuthAPIClient : AFHTTPClient

+ (id)sharedClient;

@end
