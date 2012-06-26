//
//  MasterViewController.m
//  CustomizingNavigationBar
//
//  Created by Ben Scheirman on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Friends"
                                                        image:nil
                                                          tag:0];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-activity-selected.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-activity.png"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self titleView];
    self.navigationItem.rightBarButtonItem = [self checkInButton];

    _objects = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [_objects addObject:@"Row"];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (UIView *)titleView {
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = 0.95 * self.view.frame.size.width;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];

    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat logoY = floorf((navBarHeight - logo.size.height) / 2.0f);
    [logoButton setFrame:CGRectMake(0, logoY, logo.size.width, logo.size.height)];
    [logoButton setImage:logo forState:UIControlStateNormal];
    
    UIImage *bubble = [UIImage imageNamed:@"notification-bubble-empty.png"];
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:bubble];
    
    const CGFloat Padding = 5.0f;
    CGFloat bubbleX = 
        logoButton.frame.size.width + 
        logoButton.frame.origin.x + 
        Padding;
    CGFloat bubbleY = floorf((navBarHeight - bubble.size.height) / 2.0f);
    CGRect bubbleRect = bubbleView.frame;
    bubbleRect.origin.x = bubbleX;
    bubbleRect.origin.y = bubbleY;
    bubbleView.frame = bubbleRect;
    
    [containerView addSubview:logoButton];
    [containerView addSubview:bubbleView];
    
    return containerView;
}

- (UIBarButtonItem *)checkInButton {
    UIImage *checkInImage = [UIImage imageNamed:@"global-checkin-button.png"];
    UIImage *checkInPressed = [UIImage imageNamed:@"global-checkin-button-pressed.png"];
    UIButton *checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [checkInButton setBackgroundImage:checkInImage forState:UIControlStateNormal];
    [checkInButton setBackgroundImage:checkInPressed forState:UIControlStateHighlighted];
    
    const CGFloat BarButtonOffset = 5.0f;
    [checkInButton setFrame:CGRectMake(BarButtonOffset, 0, checkInImage.size.width, checkInImage.size.height)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, checkInImage.size.width, checkInImage.size.height)];
    [containerView addSubview:checkInButton];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    return item;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [_objects objectAtIndex:indexPath.row];
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