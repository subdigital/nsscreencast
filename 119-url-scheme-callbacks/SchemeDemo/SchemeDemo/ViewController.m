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
    
    __weak id welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"WordReversed"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      ViewController *strongSelf = welf;
                                                      strongSelf.textField.text = note.object;
                                                  }];
}

- (IBAction)reverseItTapped:(id)sender {
    
    NSString *word = self.textField.text;
    if (word.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"x-callback-wordrev://x-callback-url?x-source=SchemeDemo&x-success=%@&x-error=%@&x-cancel=%@&word=%@",
                                           @"schemedemo://success",
                                           @"schemedemo://error",
                                           @"schemedemo://cancel",
                                           [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"No app handles: %@", url);
        }
    }
}

@end
