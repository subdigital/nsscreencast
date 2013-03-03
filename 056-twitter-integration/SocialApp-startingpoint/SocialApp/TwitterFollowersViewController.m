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
    // TODO
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter Followers";
    self.navigationItem.rightBarButtonItem = [self doneButton];
    self.navigationItem.leftBarButtonItem = [self tweetButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.576 blue:0.752 alpha:1.000];
    
    [self.tableView registerClass:[TwitterFollowerCell class]
           forCellReuseIdentifier:@"Cell"];
    
}

- (void)fetchTwitterFollowersForAccount:(ACAccount *)twitterAccount {
}

#pragma mark - Table view data source

- (NSArray *)followers {
    return self.followerDictionary[@"users"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count =[[self followers] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Follower";
    
    return cell;
}

@end
