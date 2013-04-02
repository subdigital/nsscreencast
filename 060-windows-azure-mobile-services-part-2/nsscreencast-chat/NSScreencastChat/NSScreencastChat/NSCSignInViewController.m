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
    [self.client loginWithProvider:@"twitter"
                      onController:self
                          animated:YES
                        completion:^(MSUser *user, NSError *error) {
                            if (error) {
                                [[[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to sign in"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] show];
                            } else {
                                self.client.currentUser = user;
                                [self setUser:user.userId];
                            }
                        }];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismiss];
}

- (void)setUser:(NSString *)name {
    NSCUser *user = [[NSCUser alloc] init];
    user.deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    MSTable *usersTable = [self.client getTable:@"Users"];
    [usersTable insert:[user attributes]
            completion:^(NSDictionary *item, NSError *error) {
                if (item) {
                    user.userId = [item[@"id"] intValue];
                    [[NSUserDefaults standardUserDefaults] setInteger:user.userId forKey:@"userId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self dismiss];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                                message:@"Couldn't create your account"
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                }
            }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end