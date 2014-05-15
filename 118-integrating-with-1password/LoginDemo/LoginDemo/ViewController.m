//
//  ViewController.m
//  LoginDemo
//
//  Created by ben on 4/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *passwordManagerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[UIApplication sharedApplication] canOpenURL:[self passwordManagerURL]])  {
        self.passwordManagerButton.hidden = YES;
    }
}

- (NSURL *)passwordManagerURL {
    return [NSURL URLWithString:@"onepassword://search/twitter.com"];
}

- (IBAction)openPasswordManagerTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[self passwordManagerURL]];
}

@end
