//
//  TwitterAccountStore.h
//  CleanTableViews
//
//  Created by ben on 1/6/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

extern NSString * const TwitterAccountStoreErrorDomain;

NS_ENUM(NSInteger, TwitterAccountStoreErrorCodes) {
    TwitterAccountStoreNoAccountsError = 0,
    TwitterAccountStoreAccessDeniedError
};

@interface TwitterAccountStore : NSObject

- (instancetype)initWithAccountStore:(ACAccountStore *)accountStore;
- (void)fetchDefaultTwitterAccount:(void (^)(ACAccount *account, NSError *error))completion;

@end
