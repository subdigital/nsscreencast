//
//  ViewController.m
//  iap
//
//  Created by ben on 12/2/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "MyIAPGateway.h"
#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "MAConfirmButton.h"
#import "SVProgressHUD.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *products;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Products";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(restorePurchases)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadProducts) forControlEvents:UIControlEventValueChanged];
    
    [self.refreshControl beginRefreshing];
    [self loadProducts];
}

- (void)loadProducts {
    [[MyIAPGateway sharedGateway] fetchProductsWithCompletion:^(BOOL worked, NSArray *products) {
        if (worked) {
            self.products = products;
            [self.tableView reloadData];
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onProductPurchased:)
                                                 name:IAPGatewayProductPurchasedNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onProductPurchased:(NSNotification *)notification {
    NSString *productId = notification.object;
    [self.products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKProduct *product = obj;
        if ([product.productIdentifier isEqualToString:productId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    [SVProgressHUD showSuccessWithStatus:@"Thanks!"];
}

- (void)restorePurchases {
    [SVProgressHUD show];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    
    SKProduct *product = self.products[indexPath.row];
    
    if ([[MyIAPGateway sharedGateway] isProductPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = [self purchaseButtonForProduct:product];
    }
    
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = product.localizedDescription;
    
    return cell;
}

- (MAConfirmButton *)purchaseButtonForProduct:(SKProduct *)product {
    MAConfirmButton *button =  [MAConfirmButton buttonWithTitle:@"Buy"
                                                        confirm:@"Confirm?"];
    [button addTarget:self action:@selector(purchaseProduct:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = [self.products indexOfObject:product];
    return button;
}

- (void)purchaseProduct:(id)sender {
    [SVProgressHUD show];
    MAConfirmButton *button = sender;
    [button disableWithTitle:@"Purchasing..."];
    SKProduct *productToPurchase = self.products[button.tag];
    [[MyIAPGateway sharedGateway] purchaseProduct:productToPurchase];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
