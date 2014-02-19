//
//  RecordWeightViewController.h
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordWeightViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *weightTextField;

- (BOOL)didSaveWeight;

@end

