//
//  BeerStylesViewController.m
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeerStylesViewController.h"
#import "BeersViewController.h"
#import <RestKit/RestKit.h>
#import "BeerStyle.h"
#import "BeerStyleCell.h"
#import "SVProgressHUD.h"

@interface BeerStylesViewController ()

@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, strong) BeerStyle *selectedStyle;

@end

@implementation BeerStylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"beerStyleCell";
    BeerStyleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BeerStyle *style = [self.styles objectAtIndex:indexPath.row];
    [self configureCell:cell forBeerStyle:style];
    return cell;
}

- (void)configureCell:(BeerStyleCell *)cell forBeerStyle:(BeerStyle *)style {
    cell.styleNameLabel.text = style.name;
    cell.styleDescriptionLabel.text = style.styleDescription;
    cell.styleCategoryLabel.text = style.category;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BeersViewController *beersViewController = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedStyle = [self.styles objectAtIndex:indexPath.row];
    beersViewController.beerStyle = self.selectedStyle;
}

@end
