//
//  ViewController.h
//  TableViewBasics
//
//  Created by Ben Scheirman on 2/12/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *beers;

@end
