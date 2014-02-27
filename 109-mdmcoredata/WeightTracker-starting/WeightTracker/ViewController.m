//
//  ViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "RecordWeightViewController.h"
#import "WeightEntriesViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTakenLabel;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // load last saved weight
}

- (IBAction)unwindFromLog:(UIStoryboardSegue *)logSegue {
}

- (IBAction)unwindFromRecordWeight:(UIStoryboardSegue *)recordWeightSegue {
    RecordWeightViewController *recordVC = recordWeightSegue.sourceViewController;
    if ([recordVC didSaveWeight]) {
        CGFloat weight = [recordVC.weightTextField.text floatValue];
        if (weight > 0) {
            NSLog(@"Save weight...");
        } else {
            NSLog(@"Skipping, weight was 0");
        }
    }
}


@end
