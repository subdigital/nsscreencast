//
//  SleepLogListViewController.m
//  StoryboardSample
//
//  Created by Ben Scheirman on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SleepLogListViewController.h"
#import "SleepLogCell.h"
#import "EditSleepLogViewController.h"

@interface SleepLogListViewController ()

@end

@implementation SleepLogListViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"sleepLogCell";
    if (indexPath.row % 2 == 0) {
        identifier = @"eventCell";
    }
    
    SleepLogCell *cell = (SleepLogCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSleepEventSegue"]) {
        EditSleepLogViewController *editVC = [segue destinationViewController];
        
        UITableViewCell *cell = sender;
        NSInteger index = [[self.tableView indexPathForCell:cell] row];
        
        SleepLog *log = [[SleepLog alloc] init];
        editVC.sleepLog = log;
    }
}

@end
