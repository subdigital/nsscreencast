//
//  TwitterFollowersViewController.m
//  SocialApp
//
//  Created by ben on 3/2/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "TwitterFollowersViewController.h"
#import "TwitterFollowerCell.h"
#import "UIImageView+AFNetworking.h"
#import <Social/Social.h>

@interface TwitterFollowersViewController ()

@property (nonatomic, strong) NSDictionary *followerDictionary;

@end

@implementation TwitterFollowersViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (UIBarButtonItem *)doneButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                         target:self
                                                         action:@selector(onDone:)];
}

- (UIBarButtonItem *)tweetButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                         target:self
                                                         action:@selector(onCompose:)];
}

- (void)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)onCompose:(id)sender {
    NSString *tweetText = @"I'm tweeting from iOS 6 😏";
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:tweetText];
    [self presentViewController:tweetSheet
                       animated:YES
                     completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter Followers";
    self.navigationItem.rightBarButtonItem = [self doneButton];
    self.navigationItem.leftBarButtonItem = [self tweetButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.576 blue:0.752 alpha:1.000];
    
    [self.tableView registerClass:[TwitterFollowerCell class]
           forCellReuseIdentifier:@"Cell"];
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Granted!");
                                                    ACAccount *account = [[self.accountStore accountsWithAccountType:twitterAccountType] lastObject];
                                                    [self fetchTwitterFollowersForAccount:account];
                                                } else {
                                                    NSLog(@"No permission :(  %@", error);
                                                }
                                            }];
}

- (void)fetchTwitterFollowersForAccount:(ACAccount *)twitterAccount {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = URLIFY(@"https://api.twitter.com/1.1/followers/list.json");
    id params = @{@"skip_status" : @"1", @"screen_name":@"nsscreencast", @"count": @"100"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    request.account = twitterAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *followerData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                if (followerData) {
                    NSLog(@"Response: %@", followerData);
                    self.followerDictionary = followerData;
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
}

#pragma mark - Table view data source

- (NSArray *)followers {
    return self.followerDictionary[@"users"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [[self followers] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *followerData = [self followers][indexPath.row];
    cell.textLabel.text = followerData[@"screen_name"];
    cell.detailTextLabel.text = followerData[@"description"];
    
    UIImage *defaultAvatar = [UIImage imageNamed:@"twitter_avatar.png"];
    NSURL *avatarUrl = URLIFY(followerData[@"profile_image_url"]);
    [cell.imageView setImageWithURL:avatarUrl
                   placeholderImage:defaultAvatar];
    
    return cell;
}

@end
