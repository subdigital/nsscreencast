//
//  UserAuthenticator.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/12/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "SecureMessage.h"
#import "AuthAPIClient.h"
#import "UserAuthenticator.h"

@implementation SecureMessage

+ (void)fetchSecureMessageWithSuccess:(SecureMessageBlock)success
                              failure:(SecureMessageErrorBlock)failure {
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^ (AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
    };
    
    void (^errorBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^ (AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            failure(@"Something went wrong!");
        } else {
            failure([self errorMessageForResponse:operation]);
        }
    };
    
    [[AuthAPIClient sharedClient] getPath:@"/home/index.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      successBlock(operation, responseObject);
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSInteger status = operation.response.statusCode;
                                      if (status == 401) {
                                          
                                          // refresh auth token
                                          UserAuthenticator *authenticator = [[UserAuthenticator alloc] init];
                                          [authenticator refreshLoginForOperation:operation
                                                                          success:successBlock
                                                                          failure:errorBlock];
                                          
                                      } else {
                                          errorBlock(operation, error);
                                      }
                                  }];
}

+ (NSString *)errorMessageForResponse:(AFHTTPRequestOperation *)operation {
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:nil];
    NSString *errorMessage = [json objectForKey:@"error"];
    return errorMessage;
}

@end
