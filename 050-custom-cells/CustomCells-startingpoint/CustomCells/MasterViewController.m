//
//  MasterViewController.m
//  CustomCells
//
//  Created by ben on 1/20/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Custom Cells";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.650 green:0.222 blue:0.750 alpha:1.000];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd MMM YYYY"];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    int dayTimeInterval = 60 * 60 * 24;
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:dayTimeInterval * indexPath.row];
    
    cell.textLabel.text = [self.dateFormatter stringFromDate:date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items", arc4random() % 999];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
