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
#import "SecureMessage.h"

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
    self.messageTextView.text = @"";
    
    if (![self ensureLoggedIn]) {
        return;
    }
    
    [SVProgressHUD show];
    
    SecureMessage *secureMessage = [[SecureMessage alloc] init];
    [secureMessage fetchSecureMessageWithSuccess:^(NSString *msg) {
        [SVProgressHUD dismiss];
        self.messageTextView.text = msg;
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
        self.messageTextView.text = nil;
    }];
}

- (IBAction)clearSavedCredentials:(id)sender {
    [self.credentialStore clearSavedCredentials];
}

- (BOOL)ensureLoggedIn {
    if (![self.credentialStore isLoggedIn]) {
        [LoginViewController presentModallyFromViewController:self];
        return NO;
    }
    return YES;
}


@end
