//
//  MasterViewController.m
//  PullToRefresh
//
//  Created by Ben Scheirman on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CustomPullToRefreshView.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}

@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end

@implementation MasterViewController

@synthesize pullToRefreshView;

- (void)refresh {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(popTime, backgroundQueue, ^(void){
        [_objects removeAllObjects];
        for (int i = 0; i < 25; i++) {
            [self insertNewObject:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pullToRefreshView finishLoading];
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView
                                                                    delegate:self];
    self.pullToRefreshView.contentView = [[CustomPullToRefreshView alloc] init];
    
    [self refresh];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)insertNewObject:(id)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
}

#pragma mark - Pull to refresh

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return YES;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
