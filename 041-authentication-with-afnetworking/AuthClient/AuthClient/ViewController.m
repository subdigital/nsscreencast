//
//  ViewController.m
//  AuthClient
//
//  Created by Ben Scheirman on 11/4/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "ViewController.h"
#import "CredentialStore.h"
#import "LoginViewController.h"
#import "AuthAPIClient.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) CredentialStore *credentialStore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.credentialStore = [[CredentialStore alloc] init];
}


- (IBAction)fetchMessage:(id)sender {
    if (![self ensureLoggedIn]) {
        return;
    }

    [SVProgressHUD show];
    [[AuthAPIClient sharedClient] getPath:@"/home/index.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [SVProgressHUD dismiss];
                                      self.messageTextView.text = [responseObject description];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSString *errorMessage = [NSString stringWithFormat:@"Requested failed: %@", operation.responseString];
                                      [SVProgressHUD showErrorWithStatus:errorMessage];
                                      [self.credentialStore setAuthToken:nil];
                                  }];
    
}

- (BOOL)ensureLoggedIn {
    if (![self.credentialStore isLoggedIn]) {
        [LoginViewController presentModallyFromViewController:self];
        return NO;
    }
    return YES;
}


@end
