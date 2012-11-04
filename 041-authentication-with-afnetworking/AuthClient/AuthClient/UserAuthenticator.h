//
//  UserAuthenticator.h
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CredentialStore.h"
#import "Credentials.h"

@interface UserAuthenticator : NSObject

- (void)authenticateWithCredentials:(Credentials *)credentials
                            success:(void (^)())successBlock
                            failure:(void (^)())failureBlock;

@end
