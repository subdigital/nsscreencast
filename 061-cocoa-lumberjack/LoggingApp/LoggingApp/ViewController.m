//
//  ViewController.m
//  LoggingApp
//
//  Created by ben on 3/31/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewController - viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ViewController - didReceiveMemoryWarning");
}

- (IBAction)doSomething:(id)sender {
    NSLog(@"doing something...");
}

- (IBAction)doSomethingElse:(id)sender {
    NSLog(@"doing something ELSE...");
}

- (IBAction)generate500Numbers:(id)sender {
    
    for (int i=0; i<500; i++) {
        int randomNumber = arc4random() % 1000;
        NSLog(@"Generated %d", randomNumber);
    }
}

@end
