//
//  FollowersViewController.m
//  CleanTableViews
//
//  Created by ben on 1/5/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "FollowersViewController.h"
#import <Social/Social.h>
#import "TwitterAccountStore.h"
#import "TwitterUserCell.h"
#import "TwitterAPIClient.h"
#import "TwitterFollower.h"
#import "ArrayDataSource.h"
#import "TwitterUserCell+TwitterFollower.h"

@interface FollowersViewController () <UITableViewDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *followers;
@property (nonatomic, strong) ArrayDataSource *dataSource;

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDatasource];
    
    [self fetchDefaultTwitterAccount:^(ACAccount *account) {
        [self fetchTwitterFollowersForAccount:account completion:^(NSArray *followers) {
            self.followers = followers;
            self.dataSource.items = followers;
            [self.tableView reloadData];
        }];
    }];
}

- (void)setupDatasource {
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.followers
                                              cellIdentifier:@"followerCell"
                                          configureCellBlock:^(TwitterUserCell *cell, TwitterFollower *follower) {
                                              [cell configureForFollower:follower];
                                          }];
    self.tableView.dataSource = self.dataSource;
}

- (ACAccountStore *)accountStore {
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (void)fetchDefaultTwitterAccount:(void (^)(ACAccount *account))completionBlock {
    TwitterAccountStore *twitterStore = [[TwitterAccountStore alloc] initWithAccountStore:self.accountStore];
    [twitterStore fetchDefaultTwitterAccount:^(ACAccount *account, NSError *error) {
        if (account) {
            completionBlock(account);
        } else {
            NSString *errorMessage = [self errorMessageForTwitterAccountStoreError:error];
            [[[UIAlertView alloc] initWithTitle:@"Twitter account error"
                                        message:errorMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (NSString *)errorMessageForTwitterAccountStoreError:(NSError *)error {
    switch (error.code) {
        case TwitterAccountStoreNoAccountsError:
            return @"There are no Twitter accounts set up.  Please add one in the Settings app.";
            
        case TwitterAccountStoreAccessDeniedError:
            return @"Access to Twitter accounts was not granted.";
            
        default:
            return @"Uknown error :(";
    }
}

- (void)fetchTwitterFollowersForAccount:(ACAccount *)account completion:(void (^)(NSArray *followers))completion {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    TwitterAPIClient *client = [[TwitterAPIClient alloc] init];
    [client fetchFollowersForAccount:account
                          completion:^(NSArray *followers, NSError *error) {
                              if (followers) {
                                  completion(followers);
                              } else {
                                  [[[UIAlertView alloc] initWithTitle:@"ERROR with Twitter"
                                                              message:@"Please try again later"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil] show];
                              }
                              
                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
