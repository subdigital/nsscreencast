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
    self.messageTextView.text = @"";
    
    if (![self ensureLoggedIn]) {
        return;
    }
    
    [SVProgressHUD show];
    
    [[AuthAPIClient sharedClient] getPath:@"/home/index.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [SVProgressHUD dismiss];
                                      self.messageTextView.text = operation.responseString;
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
                                      
                                      if (operation.response.statusCode == 401) {
                                          [self.credentialStore setAuthToken:nil];
                                      }
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
