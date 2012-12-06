//
//  MasterViewController.m
//  iap
//
//  Created by Ben Scheirman on 12/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <StoreKit/StoreKit.h>
#import "MyIAPGateway.h"
#import "SVProgressHUD.h"
#import "MAConfirmButton.h"

@interface MasterViewController ()
@property (nonatomic, copy) NSArray *products;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Products";
    
    self.navigationItem.rightBarButtonItem = [self restoreButton];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self refresh];
}

- (UIBarButtonItem *)restoreButton {
    return [[UIBarButtonItem alloc] initWithTitle:@"Restore"
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(restore)];
}

- (void)restore {
    [SVProgressHUD show];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)refresh {
    [[MyIAPGateway sharedGateway] fetchProductsWithBlock:^(BOOL success, NSArray *products) {
        self.products = products;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    SKProduct *product = [self.products objectAtIndex:indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = product.localizedDescription;
    
    if ([[MyIAPGateway sharedGateway] isProductPurchased:product]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = [self confirmButtonForRow:indexPath.row];
    }

    return cell;
}

- (MAConfirmButton *)confirmButtonForRow:(NSInteger)row {
    MAConfirmButton *button = [MAConfirmButton buttonWithTitle:@"Buy" confirm:@"Confirm?"];
    button.tag = row;
    [button addTarget:self
               action:@selector(purchaseProduct:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)purchaseProduct:(id)sender {
    MAConfirmButton *button = sender;
    SKProduct *product = [self.products objectAtIndex:button.tag];
    [button disableWithTitle:@"Purchasing"];
    [SVProgressHUD show];
    [[MyIAPGateway sharedGateway] purchaseProduct:product];
}

- (void)onProductPurchased:(NSNotification *)notification {
    [SVProgressHUD showSuccessWithStatus:@"Thanks!"];
    NSString *productIdentifier = notification.object;
    [self.products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKProduct *product = obj;
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onProductPurchased:)
                                                 name:IAPGatewayProductPurchased
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
