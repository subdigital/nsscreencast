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
#import "UIImageView+AFNetworking.h"
#import "TwitterAPIClient.h"

@interface FollowersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *followers;

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDefaultTwitterAccount:^(ACAccount *account) {
        [self fetchTwitterFollowersForAccount:account completion:^(NSArray *followers) {
            self.followers = followers;
            [self.tableView reloadData];
        }];
    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"followerCell";
    TwitterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *follower = self.followers[indexPath.row];
    cell.nameLabel.text = follower[@"name"];
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", follower[@"screen_name"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"avatar"];
    NSURL *avatarUrl = [NSURL URLWithString:follower[@"profile_image_url"]];
    [cell.avatarImageView setImageWithURL:avatarUrl placeholderImage:placeholderImage];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
