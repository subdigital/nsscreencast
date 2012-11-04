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
#define USERNAME_KEY @"username"
#define PASSWORD_KEY @"password"
#define AUTH_TOKEN_KEY @"auth_token"

@implementation CredentialStore

- (BOOL)isLoggedIn {
    id authToken = [self authToken];
    return (authToken != nil);
}

- (void)clearSavedCredentials {
    [self setSecureValue:nil forKey:USERNAME_KEY];
    [self setSecureValue:nil forKey:PASSWORD_KEY];
}

- (void)setCredentials:(Credentials *)credentials {
    [self setSecureValue:credentials.username forKey:USERNAME_KEY];
    [self setSecureValue:credentials.password forKey:PASSWORD_KEY];
}

- (Credentials *)storedCredentials {
    NSString *username = [self secureValueForKey:USERNAME_KEY];
    NSString *password = [self secureValueForKey:PASSWORD_KEY];
    Credentials *creds = [[Credentials alloc] init];
    creds.username = username;
    creds.password = password;
    return creds;
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed"
                                                        object:self];
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil) {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    } else {
        [SSKeychain setPassword:value forService:SERVICE_NAME account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}


@end
