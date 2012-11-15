//
//  UserAuthenticator.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/12/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SecureMessageBlock)(NSString *message);
typedef void (^SecureMessageErrorBlock)(NSString *error);

@interface SecureMessage : NSObject

+ (void)fetchSecureMessageWithSuccess:(SecureMessageBlock)success
                              failure:(SecureMessageErrorBlock)failure;

@end
