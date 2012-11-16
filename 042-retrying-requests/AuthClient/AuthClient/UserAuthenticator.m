//
//  UserAuthenticator.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/14/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "UserAuthenticator.h"
#import "CredentialStore.h"
#import "AuthAPIClient.h"

@interface UserAuthenticator ()
@property (nonatomic, strong) CredentialStore *credentialStore;
@end

@implementation UserAuthenticator

- (id)init {
    self = [super init];
    if (self) {
        self.credentialStore = [[CredentialStore alloc] init];
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(UserAuthenticatedBlock)success
                  failure:(UserAuthenticationFailedBlock)failure {
    

    id params = @{
        @"username": username,
        @"password": password
    };
    
    [[AuthAPIClient sharedClient] postPath:@"/auth/login.json?ttl=30"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSString *authToken = [responseObject objectForKey:@"auth_token"];
                                       [self.credentialStore setAuthToken:authToken];
                                       [self.credentialStore setUsername:username];
                                       [self.credentialStore setPassword:password];
                                       
                                       success();
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.response.statusCode == 500) {
                                           failure(@"Something went wrong!");
                                       } else {
                                           failure([self errorMessageForResponse:operation]);
                                       }
                                   }];
    
}

- (void)refreshTokenAndRetryOperation:(AFHTTPRequestOperation *)operation
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *username = [self.credentialStore username];
    NSString *password = [self.credentialStore password];
    
    [self loginWithUsername:username
                   password:password
                    success:^{
                        // retry request
                        NSLog(@"RETRYING REQUEST");
                        AFHTTPRequestOperation *retryOperation = [self retryOperationForOperation:operation];
                        [retryOperation setCompletionBlockWithSuccess:success
                                                              failure:failure];
                        
                        [retryOperation start];
                        
                    } failure:^(NSString *errorMessage) {
                        failure(operation, nil);
                    }];
}

- (AFHTTPRequestOperation *)retryOperationForOperation:(AFHTTPRequestOperation *)operation {
    NSMutableURLRequest *request = [operation.request mutableCopy];
    [request addValue:nil forHTTPHeaderField:@"auth_token"];
    [request addValue:[self.credentialStore authToken] forHTTPHeaderField:@"auth_token"];
    
    AFHTTPRequestOperation *retryOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    return retryOperation;
}


- (NSString *)errorMessageForResponse:(AFHTTPRequestOperation *)operation {
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:nil];
    NSString *errorMessage = [json objectForKey:@"error"];
    return errorMessage;
}

@end
