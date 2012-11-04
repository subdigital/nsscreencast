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
    
    [[AuthAPIClient sharedClient] getPath:@"/home/index.json"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      self.messageTextView.text = operation.responseString;
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"ERROR: %@", error);
                                   
                                   if (operation.response.statusCode == 401) {
                                       // auth token is bad
                                       [self.credentialStore setAuthToken:nil];
                                   }
                                   
                                   NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                                   NSString *errorMessage = [dictionary objectForKey:@"error"];
                                   [SVProgressHUD showErrorWithStatus:errorMessage];
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
