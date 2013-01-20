//
//  MenuViewController.m
//  SlideOutMenus
//
//  Created by ben on 1/13/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "MainViewController.h"
#import "AboutViewController.h"
#import "NVSlideMenuController.h"

enum {
    MenuHomeRow = 0,
    MenuAboutRow,
    MenuSettingsRow,
    MenuRowCount
};

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.173 alpha:1.000];
    self.tableView.separatorColor = [UIColor blackColor];

    [self.tableView registerNib:[self menuCellNib] forCellReuseIdentifier:@"MenuCell"];
}

- (UINib *)menuCellNib {
    return [UINib nibWithNibName:@"MenuCell" bundle:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MenuRowCount;
}

- (void)configureCell:(MenuCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuHomeRow:
            cell.label.text = @"Home";
            break;
            
        case MenuAboutRow:
            cell.label.text = @"About";
            break;
            
        case MenuSettingsRow:
            cell.label.text = @"Settings";
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - table view delegate

- (BOOL)isShowingClass:(Class)class {
    UIViewController *controller = self.slideMenuController.contentViewController;
    if ([controller isKindOfClass:class]) {
        return YES;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)controller;
        if ([navController.visibleViewController isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)showControllerClass:(Class)class {
    if ([self isShowingClass:class]) {
        [self.slideMenuController toggleMenuAnimated:self];
    } else {
        id mainVC = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        [self.slideMenuController setContentViewController:nav
                                                  animated:YES
                                                completion:nil];
    }
}

- (void)showMainController {
    [self showControllerClass:[MainViewController class]];
}

- (void)showAboutController {
    [self showControllerClass:[AboutViewController class]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuHomeRow:
            [self showMainController];
            break;
        
        case MenuAboutRow:
            [self showAboutController];
            break;
    }
}

@end
