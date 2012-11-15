//
//  UserAuthenticator.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/12/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "UserAuthenticator.h"
#import "AuthAPIClient.h"
#import "CredentialStore.h"

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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
                  success:(AuthenticationSuccessBlock)success
                  failure:(AuthenticationFailedBlock)failure {
    
    id params = @{
        @"username" : username,
        @"password" : password
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

- (void)refreshLoginForOperation:(AFHTTPRequestOperation *)operation
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *username = [self.credentialStore username];
    NSString *password = [self.credentialStore password];
    
    [self loginWithUsername:username password:password success:^{
        
        AFHTTPRequestOperation *retryOperation = [self operationForRetryingOperation:operation];
        [retryOperation setCompletionBlockWithSuccess:success failure:failure];
        [retryOperation start];
        
    } failure:^(NSString *error) {
        failure(operation, nil);
    }];
}

- (AFHTTPRequestOperation *)operationForRetryingOperation:(AFHTTPRequestOperation *)operation {
    NSMutableURLRequest *request = [operation.request mutableCopy];
    [request addValue:nil forHTTPHeaderField:@"auth_token"];
    [request addValue:[self.credentialStore authToken] forHTTPHeaderField:@"auth_token"];
    AFJSONRequestOperation *retryOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
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
