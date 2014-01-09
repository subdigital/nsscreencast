//
//  FollowersViewController.m
//  CleanTableViews
//
//  Created by ben on 1/5/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "FollowersViewController.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "TwitterUserCell.h"
#import "UIImageView+AFNetworking.h"

@interface FollowersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *followers;

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Request granted");
                                                    ACAccount *twitterAccount = [[self.accountStore accountsWithAccountType:twitterType] firstObject];
                                                    
                                                    if (twitterAccount) {
                                                        NSLog(@"Using account: %@", twitterAccount.username);
                                                        [self fetchTwitterFollowersForAccount:twitterAccount];
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [[[UIAlertView alloc] initWithTitle:@"No twitter accounts"
                                                                                        message:@"Set up your Twitter account in Settings first"
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil] show];
                                                        });
                                                    }
                                                } else {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[[UIAlertView alloc] initWithTitle:@"No permission"
                                                                                    message:@"We need permission to access your Twitter account"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil] show];
                                                        
                                                    });
                                                }
                                            }];
}

- (void)fetchTwitterFollowersForAccount:(ACAccount *)account {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
    NSDictionary *params = @{
                             @"skip_status": @"1",
                             @"count": @"500"
                             };
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    request.account = account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *followerData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                if (followerData) {
                    NSLog(@"Response: %@", followerData);
                    self.followers = followerData[@"users"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                } else {
                    NSLog(@"JSON Parsing error: %@", jsonError);
                }
            } else {
                NSLog(@"Server returned HTTP %d", urlResponse.statusCode);
            }
        } else {
            NSLog(@"Something went wrong: %@", [error localizedDescription]);
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
