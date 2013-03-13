//
//  ViewController.m
//  SocialApp
//
//  Created by ben on 2/17/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TwitterFollowersViewController.h"
#import "FacebookFriendsViewController.h"


@interface ViewController ()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAccountStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAccountStoreChanged:)
                                                 name:ACAccountStoreDidChangeNotification
                                               object:nil];
}

- (void)onAccountStoreChanged:(NSNotification *)notification {
    if ([self presentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self setupAccountStore];
        }];
    }
}

- (void)setupAccountStore {
    self.accountStore = [[ACAccountStore alloc] init];
}

- (IBAction)onTwitterTapped:(id)sender {
    TwitterFollowersViewController *twvc = [[TwitterFollowersViewController alloc] init];
    twvc.accountStore = self.accountStore;
    
    [self presentViewController:NAVIFY(twvc)
                       animated:YES
                     completion:nil];
}

- (IBAction)onFacebookTapped:(id)sender {
    FacebookFriendsViewController *fbvc = [[FacebookFriendsViewController alloc] init];
    fbvc.accountStore = self.accountStore;
    [self presentViewController:NAVIFY(fbvc)
                       animated:YES
                     completion:nil];
}

@end
