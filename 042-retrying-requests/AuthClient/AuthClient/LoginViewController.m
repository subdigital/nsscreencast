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
    
    id params = @{
        @"username": self.usernameField.text,
        @"password": self.passwordField.text
    };
    
    [[AuthAPIClient sharedClient] postPath:@"/auth/login.json?ttl=30"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSString *authToken = [responseObject objectForKey:@"auth_token"];
                                       [self.credentialStore setAuthToken:authToken];
                                       [self.credentialStore setUsername:self.usernameField.text];
                                       [self.credentialStore setPassword:self.passwordField.text];
                                       
                                       [SVProgressHUD dismiss];
                                       
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.response.statusCode == 500) {
                                           [SVProgressHUD showErrorWithStatus:@"Something went wrong!"];
                                       } else {
                                           NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                options:0
                                                                                                  error:nil];
                                           NSString *errorMessage = [json objectForKey:@"error"];
                                           [SVProgressHUD showErrorWithStatus:errorMessage];
                                       }
                                   }];
    
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
