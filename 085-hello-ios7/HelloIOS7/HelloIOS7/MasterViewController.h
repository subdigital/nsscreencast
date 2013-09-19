//
//  MasterViewController.h
//  HelloIOS7
//
//  Created by ben on 9/14/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
