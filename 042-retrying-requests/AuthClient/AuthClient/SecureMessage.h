//
//  SecureMessage.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/14/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SecureMessageBlock)(NSString *msg);
typedef void (^SecureMessageErrorBlock)(NSString *errorMessage);

@interface SecureMessage : NSObject

- (void)fetchSecureMessageWithSuccess:(SecureMessageBlock)success
                              failure:(SecureMessageErrorBlock)failure;

@end
