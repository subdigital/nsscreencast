//
//  CredentialStore.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "CredentialStore.h"
#import "SSKeychain.h"

#define SERVICE_NAME @"NSScreencast-AuthClient"
#define AUTH_TOKEN_KEY @"auth_token"
#define USERNAME_KEY @"username"
#define PASSWORD_KEY @"password"

@implementation CredentialStore

- (BOOL)isLoggedIn {
    return [self authToken] != nil;
}

- (void)clearSavedCredentials {
    [self setAuthToken:nil];
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (NSString *)username {
    return [self secureValueForKey:USERNAME_KEY];
}

- (NSString *)password {
    return [self secureValueForKey:PASSWORD_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed" object:self];
}

- (void)setUsername:(NSString *)username {
    [self setSecureValue:username forKey:USERNAME_KEY];
}

- (void)setPassword:(NSString *)password {
    [self setSecureValue:password forKey:PASSWORD_KEY];
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}

@end
