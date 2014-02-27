//
//  WeightEntriesViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "WeightEntriesViewController.h"
#import <CoreData/CoreData.h>

@interface WeightEntriesViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation WeightEntriesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // fix a jumping nav bar bug in iOS 7 http://stackoverflow.com/a/19265558/3381
    [self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Recent Entries";
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateStyle:NSDateFormatterShortStyle];
    });
    
    return __dateFormatter;
}

@end
