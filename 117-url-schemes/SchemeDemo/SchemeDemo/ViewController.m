//
//  ViewController.m
//  SchemeDemo
//
//  Created by ben on 4/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)reverseItTapped:(id)sender {
    
    NSString *word = self.textField.text;
    if (word.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"wordrev://%@", word]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"No app handles: %@", url);
        }
    }
}

@end
