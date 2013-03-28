//
//  NSCSignInViewController.m
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCSignInViewController.h"
#import "NSCUser.h"

@interface NSCSignInViewController ()

@end

@implementation NSCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)twitterTapped:(id)sender {
    // TODO
}

- (IBAction)cancelTapped:(id)sender {
    [self dismiss];
}

- (void)setUser:(NSString *)name {
    // TODO
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end