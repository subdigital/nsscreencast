//
//  LoginViewController.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthAPIClient.h"
#import "CredentialStore.h"
#import "SVProgressHUD.h"
#import "UserAuthenticator.h"

@interface LoginViewController ()
@property (nonatomic, strong) CredentialStore *credentialStore;
@end

@implementation LoginViewController

+ (void)presentModallyFromViewController:(UIViewController *)viewController {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:loginViewController];
    [viewController presentViewController:navController
                                 animated:YES
                               completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(login:)];
    
    [self.usernameField becomeFirstResponder];
}

- (void)login:(id)sender {
    [SVProgressHUD show];
    
    UserAuthenticator *authenticator = [[UserAuthenticator alloc] init];
    [authenticator loginWithUsername:self.usernameField.text
                            password:self.passwordField.text
                             success:^{
                                [SVProgressHUD dismiss];
                                [self dismissViewControllerAnimated:YES completion:nil];
                             } failure:^(NSString *error) {
                                 [SVProgressHUD showErrorWithStatus:error];
                             }];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
