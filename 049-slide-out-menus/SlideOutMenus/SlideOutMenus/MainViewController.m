//
//  MainViewController.m
//  SlideOutMenus
//
//  Created by ben on 1/12/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "MainViewController.h"
#import "NVSlideMenuController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (UIImage *)listImage {
    return [UIImage imageNamed:@"list.png"];
}

- (UIBarButtonItem *)slideOutBarButton {
    return [[UIBarButtonItem alloc] initWithImage:[self listImage]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(slideOut:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"MainCell"];
    
    self.navigationItem.leftBarButtonItem = [self slideOutBarButton];
}

#pragma mark - Event handlers

- (void)slideOut:(id)sender {
    [self.slideMenuController toggleMenuAnimated:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Main Cell %d", indexPath.row];
    
    return cell;
}

@end
