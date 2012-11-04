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
    
    self.credentialStore = [[CredentialStore alloc] init];
    
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
    Credentials *creds = [[Credentials alloc] init];
    creds.username = self.usernameField.text;
    creds.password = self.passwordField.text;
    
    id params = @{
        @"username": creds.username,
        @"password": creds.password
    };
    
    [[AuthAPIClient sharedClient] postPath:@"/auth/login.json"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self.credentialStore setCredentials:creds];
                                       
                                       NSString *authToken = [responseObject objectForKey:@"auth_token"];
                                       NSLog(@"Updated auth token: %@", authToken);
                                       [self.credentialStore setAuthToken:authToken];
                                       
                                       [SVProgressHUD dismiss];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"ERROR: %@", error);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:0
                                                                                                    error:nil];
                                       NSString *errorMessage = [dictionary objectForKey:@"error"];
                                       [SVProgressHUD showErrorWithStatus:errorMessage];
                                   }];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
