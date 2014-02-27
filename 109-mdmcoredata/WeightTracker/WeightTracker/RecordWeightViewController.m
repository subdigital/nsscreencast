//
//  RecordWeightViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "RecordWeightViewController.h"

@interface RecordWeightViewController () {
    BOOL _didSave;
}

@end

@implementation RecordWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.weightTextField becomeFirstResponder];
}

- (IBAction)save:(id)sender {
    _didSave = YES;
    
    [self performSegueWithIdentifier:@"saveSegue" sender:self];
}

- (BOOL)didSaveWeight {
    return _didSave;
}

@end
