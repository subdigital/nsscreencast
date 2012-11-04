//
//  UserAuthenticator.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "UserAuthenticator.h"
#import "AuthAPIClient.h"

@implementation UserAuthenticator

- (void)authenticateWithCredentials:(Credentials *)credentials
                            success:(void (^)())successBlock
                            failure:(void (^)())failureBlock {
    id params = @{
      @"username": credentials.username,
      @"password": credentials.password
    };
    
    [[AuthAPIClient sharedClient] postPath:@"/auth/login.json"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSString *token = [responseObject objectForKey:@"auth_token"];
                                       
                                       CredentialStore *store = [[CredentialStore alloc] init];
                                       [store setAuthToken:token];
                                       [store setCredentials:credentials];

                                       successBlock();
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       failureBlock();
                                   }];
}

@end
