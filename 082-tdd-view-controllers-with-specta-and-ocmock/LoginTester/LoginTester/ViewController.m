//
//  ViewController.m
//  LoginTester
//
//  Created by ben on 8/24/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.loginService = [[LoginService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginTapped:(id)sender {
    [self.loginService verifyUsername:self.usernameTextField.text
                             password:self.passwordTextField.text
                           completion:nil];
}

@end
