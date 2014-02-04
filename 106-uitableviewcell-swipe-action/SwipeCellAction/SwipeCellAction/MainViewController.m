//
// Created by Ben Scheirman on 2/3/14.
// Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "MainViewController.h"
#import "SwipeCell.h"


@implementation MainViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Cell Swiping Action";

    [self.tableView registerClass:[SwipeCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Content for Row %d", indexPath.row];
    return cell;
}


@end