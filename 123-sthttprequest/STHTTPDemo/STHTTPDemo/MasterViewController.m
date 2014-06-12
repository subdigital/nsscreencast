//
//  MasterViewController.m
//  STHTTPDemo
//
//  Created by Ben Scheirman on 5/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "MasterViewController.h"
#import "ITunesClient.h"

@interface MasterViewController () {
}

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)fetchTapped:(id)sender {
    ITunesClient *client = [[ITunesClient alloc] init];
    [client search:@"Breaking" completion:^(NSArray *results, NSError *error) {
        NSLog(@"Found %ld results", results.count);
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

@end
