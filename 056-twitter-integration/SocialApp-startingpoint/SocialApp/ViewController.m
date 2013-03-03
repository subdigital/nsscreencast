//
//  ViewController.m
//  SocialApp
//
//  Created by ben on 2/17/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "TwitterFollowersViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)onTwitterTapped:(id)sender {
    TwitterFollowersViewController *twvc = [[TwitterFollowersViewController alloc] init];
    
    [self presentViewController:NAVIFY(twvc)
                       animated:YES
                     completion:nil];
}

@end
