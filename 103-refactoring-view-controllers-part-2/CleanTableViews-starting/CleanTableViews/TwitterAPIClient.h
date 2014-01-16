//
//  TwitterAPIClient.h
//  CleanTableViews
//
//  Created by ben on 1/6/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterAPIClient : NSObject

- (void)fetchFollowersForAccount:(ACAccount *)account
                      completion:(void (^)(NSArray *followers, NSError *error))completion;

@end
