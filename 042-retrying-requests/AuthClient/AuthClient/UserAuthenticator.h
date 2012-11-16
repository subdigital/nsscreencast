//
//  UserAuthenticator.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/14/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^UserAuthenticatedBlock)();
typedef void (^UserAuthenticationFailedBlock)(NSString *errorMessage);

@interface UserAuthenticator : NSObject

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(UserAuthenticatedBlock)success
                  failure:(UserAuthenticationFailedBlock)failure;


- (void)refreshTokenAndRetryOperation:(AFHTTPRequestOperation *)operation
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
