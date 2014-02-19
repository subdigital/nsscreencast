//
//  ViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "RecordWeightViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)unwindFromRecordWeight:(UIStoryboardSegue *)segue {
    NSLog(@"Came from entry screen");
    
    RecordWeightViewController *recordVC = (RecordWeightViewController *)segue.sourceViewController;
    if ([recordVC didSaveWeight]) {
        NSLog(@"You entered %@", recordVC.weightTextField.text);
    } else {
        NSLog(@"--cancelled--");
    }
}

- (IBAction)unwindFromLog:(UIStoryboardSegue *)segue {
    NSLog(@"Came from log");
}


@end
