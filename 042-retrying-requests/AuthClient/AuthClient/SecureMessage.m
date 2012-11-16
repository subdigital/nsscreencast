//
//  SecureMessage.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/14/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "SecureMessage.h"
#import "AuthAPIClient.h"
#import "CredentialStore.h"
#import "UserAuthenticator.h"

@interface SecureMessage ()
@property (nonatomic, strong) CredentialStore *credentialStore;
@end

@implementation SecureMessage

- (id)init {
    self = [super init];
    if (self) {
        self.credentialStore = [[CredentialStore alloc] init];
    }
    return self;
}

- (NSString *)errorMessageForResponse:(AFHTTPRequestOperation *)operation
{
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:nil];
    NSString *errorMessage = [json objectForKey:@"error"];
    return errorMessage;
}

- (void)fetchSecureMessageWithSuccess:(SecureMessageBlock)success
                              failure:(SecureMessageErrorBlock)failure {
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            failure(@"Something went wrong!");
        } else {
            NSString *errorMessage = [self errorMessageForResponse:operation];
            failure(errorMessage);
        }
    };
    
    [[AuthAPIClient sharedClient] getPath:@"/home/index.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      processSuccessBlock(operation, responseObject);
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      processFailureBlock(operation, error);
                                      
                                      if (operation.response.statusCode == 401) {
                                          [self.credentialStore setAuthToken:nil];
                                          
                                          // retry logic
                                          UserAuthenticator *auth = [[UserAuthenticator alloc] init];
                                          [auth refreshTokenAndRetryOperation:operation
                                                                      success:processSuccessBlock
                                                                      failure:processFailureBlock];
                                      }
                                  }];
}

@end
