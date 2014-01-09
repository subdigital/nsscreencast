//
//  TwitterAccountStore.m
//  CleanTableViews
//
//  Created by ben on 1/6/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "TwitterAccountStore.h"

NSString * const TwitterAccountStoreErrorDomain = @"TwitterAccountStoreErrorDomain";

@interface TwitterAccountStore ()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation TwitterAccountStore

- (instancetype)initWithAccountStore:(ACAccountStore *)accountStore {
    self = [super init];
    if (self) {
        self.accountStore = accountStore;
    }
    return self;
}

- (ACAccountType *)accountType {
    return [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
}

- (void)fetchDefaultTwitterAccount:(void (^)(ACAccount *account, NSError *error))completion {
    ACAccountType *accountType = [self accountType];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                if (granted) {
                                                    NSLog(@"Request granted");
                                                    ACAccount *twitterAccount = [[self.accountStore accountsWithAccountType:accountType] firstObject];
                                                    
                                                    if (twitterAccount) {
                                                        NSLog(@"Using account: %@", twitterAccount.username);
                                                        completion(twitterAccount, nil);
                                                    } else {
                                                        completion(nil, [self noAccountsError]);
                                                    }
                                                } else {
                                                    completion(nil, [self noAccessError]);
                                                }
                                                });
                                            }];
}

- (NSError *)noAccountsError {
    return [self errorWithCode:TwitterAccountStoreNoAccountsError];
}

- (NSError *)noAccessError {
    return [self errorWithCode:TwitterAccountStoreAccessDeniedError];
}

- (NSError *)errorWithCode:(NSInteger)code {
    NSError *error = [NSError errorWithDomain:TwitterAccountStoreErrorDomain
                                         code:code
                                     userInfo:@{}];
    return error;
}

@end
