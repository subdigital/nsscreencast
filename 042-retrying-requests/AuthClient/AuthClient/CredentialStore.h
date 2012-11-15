//
//  CredentialStore.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialStore : NSObject

- (BOOL)isLoggedIn;
- (void)clearSavedCredentials;
- (NSString *)authToken;
- (NSString *)username;
- (NSString *)password;
- (void)setAuthToken:(NSString *)authToken;
- (void)setUsername:(NSString *)username;
- (void)setPassword:(NSString *)password;

@end
