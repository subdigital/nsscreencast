//
//  ViewController.h
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMCoreData.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) MDMPersistenceController *persistenceController;

@end
