//
//  TwitterFollowersViewController.h
//  SocialApp
//
//  Created by ben on 3/2/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface TwitterFollowersViewController : UITableViewController

@property (nonatomic, strong) ACAccountStore *accountStore;

@end
