//
//  UserAuthenticator.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/12/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^AuthenticationSuccessBlock)();
typedef void (^AuthenticationFailedBlock)(NSString *error);

@interface UserAuthenticator : NSObject

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
                  success:(AuthenticationSuccessBlock)success
                  failure:(AuthenticationFailedBlock)failure;

- (void)refreshLoginForOperation:(AFHTTPRequestOperation *)operation
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
