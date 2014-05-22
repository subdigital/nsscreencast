//
//  MasterViewController.h
//  MantleDemo
//
//  Created by Ben Scheirman on 4/19/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMPersistenceController.h"

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) MDMPersistenceController *persistenceController;

@end
