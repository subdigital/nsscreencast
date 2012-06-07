/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UAStoreFront.h"
#import "UAStoreFrontViewController.h"
#import "UAProductDetailViewController.h"
#import "UAStoreFrontCell.h"
#import "UAViewUtils.h"
#import "UAStoreFrontUI.h"
#import "UAInventory.h"
#import "UAAsycImageView.h"

// Weak link to this notification since it doesn't exist in iOS 3.x
UIKIT_EXTERN NSString* const UIApplicationDidEnterBackgroundNotification __attribute__((weak_import));
UIKIT_EXTERN NSString* const UIApplicationDidBecomeActiveNotification __attribute__((weak_import));

@implementation UAStoreFrontViewController

@synthesize productTable;
@synthesize filterSegmentedControl;
@synthesize activityView;
@synthesize statusLabel;
@synthesize detailViewController;
@synthesize loadingView;
@synthesize toolBar;
@dynamic products;
@synthesize productID;

#pragma mark -
#pragma mark UIViewController

- (void)dealloc {
    [UAStoreFront unregisterObserver:self];

    RELEASE_SAFELY(productID);
    RELEASE_SAFELY(productTable);
    RELEASE_SAFELY(filterSegmentedControl);
    RELEASE_SAFELY(activityView);
    RELEASE_SAFELY(statusLabel);
    RELEASE_SAFELY(filteredProducts);
    RELEASE_SAFELY(productDetailViewNibName);
    RELEASE_SAFELY(productDetailViewClassName);
    RELEASE_SAFELY(detailViewController);

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initNibNames];
        detailViewController = [[NSClassFromString(productDetailViewClassName) alloc]
                                initWithNibName:productDetailViewNibName
                                bundle:nil];
        productID = nil;
    }
    return self;
}

- (void)initNibNames {
    productDetailViewNibName = [@"UAProductDetail" retain];
    productDetailViewClassName = [@"UAProductDetailViewController" retain];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    wasBackgrounded = NO;

    IF_IOS4_OR_GREATER(
        if (&UIApplicationDidEnterBackgroundNotification != NULL) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(enterBackground)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }

        if (&UIApplicationDidBecomeActiveNotification != NULL) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(enterForeground)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
        }
                       );

    self.title = UA_SF_TR(@"UA_Content");

    [filterSegmentedControl setTitle:UA_SF_TR(@"UA_filter_all") forSegmentAtIndex:ProductTypeAll];
    [filterSegmentedControl setTitle:UA_SF_TR(@"UA_filter_installed") forSegmentAtIndex:ProductTypeInstalled];
    [filterSegmentedControl setTitle:UA_SF_TR(@"UA_filter_updates") forSegmentAtIndex:ProductTypeUpdated];
    [filterSegmentedControl setEnabled:NO forSegmentAtIndex:ProductTypeInstalled];
    [filterSegmentedControl setEnabled:NO forSegmentAtIndex:ProductTypeUpdated];
    [filterSegmentedControl setSelectedSegmentIndex:ProductTypeAll];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(done:)] autorelease];

    statusLabel.text = UA_SF_TR(@"UA_Loading");
    statusLabel.hidden = NO;
    [activityView startAnimating];
    
    filteredProducts = [[NSMutableArray alloc] init];

    [self customTableViewContentOffset];

    [UAStoreFront registerObserver:self];
    [UAStoreFront loadInventory];
}

// App is backgrounding, so unregister observers in prep for data reload later
- (void)enterBackground {

    [activityView stopAnimating];

    wasBackgrounded = YES;
    [UAStoreFront unregisterObserver:self];
}

// App is returning to foreground, so reregister observers and reload data
- (void)enterForeground {

    // Things other than a backgrounding can trigger this message, only recover
    // if it is truly from being backgrounded
    if (wasBackgrounded) {
        wasBackgrounded = NO;

        // Need to remove all references to old objects
        [filteredProducts removeAllObjects];

        [UAStoreFront registerObserver:self];
        [UAStoreFront resetAndLoadInventory];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [UAStoreFront reloadInventoryIfFailed];
    if(![UAStoreFrontUI shared].isiPad) {
        [self.productTable deselectRowAtIndexPath:[self.productTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)viewDidUnload {
    self.productTable = nil;
    self.filterSegmentedControl = nil;
    self.activityView = nil;
    self.statusLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.searchDisplayController.searchBar setNeedsLayout];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.productTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataSource = [self productsForTableView:tableView];
    detailViewController.product = [dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)loadProduct {
    NSArray *dataSource = [self productsForTableView:productTable];
    UAProduct *aProduct;

    for (int i=0; i<dataSource.count; i++) {
        aProduct = [dataSource objectAtIndex:i];
        if ([aProduct.productIdentifier isEqualToString:productID]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [productTable selectRowAtIndexPath:indexPath
                                      animated:YES
                                scrollPosition:UITableViewScrollPositionNone];
            [self tableView:productTable didSelectRowAtIndexPath:indexPath];
            return;
        }
    }
    // TODO: 1.should change error content?
    // 2.support other language
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                    message:[NSString stringWithFormat:@"Load %@ error", productID]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)loadProduct:(NSString*)aProductID {
    self.productID = aProductID;
    if ([UAStoreFront shared].inventory.status == UAInventoryStatusUnloaded
        || [UAStoreFront shared].inventory.status == UAInventoryStatusFailed) {
        [UAStoreFront loadInventory];
    } else if ([UAStoreFront shared].inventory.status == UAInventoryStatusLoaded) {
        [self loadProduct];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ((UAStoreFrontCell *)cell).isOdd = indexPath.row%2;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UAStoreFrontCell *cell = (UAStoreFrontCell *)[tableView dequeueReusableCellWithIdentifier:@"store-front-cell"];
    if (cell == nil) {
        cell = [[[UAStoreFrontCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"store-front-cell"] autorelease];
        [UAViewUtils roundView:cell.iconContainer borderRadius:10 borderWidth:1 color:[UIColor darkGrayColor]];
    }

    NSArray *tableProducts = [self productsForTableView:tableView];
    if (indexPath.row < [tableProducts count]) {
        cell.product = [tableProducts objectAtIndex:indexPath.row];
    }
    [self customizeAccessoryViewForCell:cell];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataSource = [self productsForTableView:tableView];
    return [dataSource count];
}

#pragma mark -

- (void)customizeAccessoryViewForCell:(UITableViewCell *)cell {
    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]] autorelease];
}

- (void)customTableViewContentOffset {
    self.productTable.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.bounds.size.height);
}

// Products list for current UI
- (NSArray *)productsForTableView:(UITableView *)tableView {
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return filteredProducts;
    } else {
        return self.products;
    }
}

- (NSArray*)products {
    return [UAStoreFront productsForType:filterSegmentedControl.selectedSegmentIndex];
}

#pragma mark -

- (void)refreshExitButton {
    // Optional if you want to disable the "Done" button in StoreFront while
    // there are active downloads, just directly set:
    // self.navigationItem.leftBarButtonItem.enabled = YES

    self.navigationItem.leftBarButtonItem.enabled = YES;
    for (UAProduct *product in [UAStoreFront productsForType:ProductTypeAll]) {
        if (product.status == UAProductStatusDownloading
            || product.status == UAProductStatusPurchasing
            || product.status == UAProductStatusDecompressing
            || product.status == UAProductStatusVerifyingReceipt) {
            self.navigationItem.leftBarButtonItem.enabled = NO;
            break;
        }
    }
}

- (void)refreshUI {

    // update segmented control
    NSUInteger updateCount = [UAStoreFront productsForType:ProductTypeUpdated].count;
    NSUInteger installCount = [UAStoreFront productsForType:ProductTypeInstalled].count;

    NSString *updatesString = UA_SF_TR(@"UA_filter_updates");
    if (updateCount > 0) {
        updatesString = [updatesString stringByAppendingFormat:@"(%d)", updateCount];
    }

    [filterSegmentedControl setTitle:updatesString
                   forSegmentAtIndex:ProductTypeUpdated];
    [filterSegmentedControl setEnabled:!!updateCount
                     forSegmentAtIndex:ProductTypeUpdated];
    [filterSegmentedControl setEnabled:!!installCount
                     forSegmentAtIndex:ProductTypeInstalled];

    // update 'update all' button
    const int UPDATE_ALL_LOWER_BOUND = 2;
    if (updateCount >= UPDATE_ALL_LOWER_BOUND) {
        NSString *buttonText = UA_SF_TR(@"UA_update_all");
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:buttonText
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(updateAll)]
                                                  autorelease];
    } else {
        self.navigationItem.rightBarButtonItem = nil;

        NSString* buyString = UA_SF_TR(@"UA_Restore");
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:buyString
                                                                                   style:UIBarButtonItemStyleDone
                                                                                  target:self
                                                                                  action:@selector(restoreAll)] autorelease];
    }

    [self refreshExitButton];
    [self.productTable reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];

}

#pragma mark -
#pragma mark UAInventory status observer

- (void)inventoryProductsChanged:(NSNumber *)status {
    [self refreshExitButton];
}

- (void)restoreStatusChanged:(NSNumber *)inRestoring {
    self.navigationItem.rightBarButtonItem.enabled = ![inRestoring boolValue];
}

- (void)inventoryStatusChanged:(NSNumber *)status {
    NSString *statusString = nil;
    UAInventoryStatus st = [status intValue];

    if (st == UAInventoryStatusDownloading) {
        [self showLoading];
        statusString = UA_SF_TR(@"UA_Status_Downloading");

    } else if(st == UAInventoryStatusApple) {
        [self showLoading];
        statusString = UA_SF_TR(@"UA_Status_Apple");

    } else if(st == UAInventoryStatusFailed) {
        [self showLoading];
        statusString = UA_SF_TR(@"UA_Status_Failed");
        self.productID = nil;

    } else if(st == UAInventoryStatusPurchaseDisabled) {
        [self showLoading];
        statusString = UA_SF_TR(@"UA_Status_Disabled");
        self.productID = nil;

    } else if (st == UAInventoryStatusLoaded) {

        if ([UAStoreFront productsForType:ProductTypeAll].count == 0) {
            statusString = UA_SF_TR(@"UA_No_Content");
            [self showLoading];
        } else {
            [self hideLoading];

            if(self.searchDisplayController.active) {
                [self filterContentForSearchText:self.searchDisplayController.searchBar.text];
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            
            if (self.productID != nil) {
                [self loadProduct:productID];
            }

            [self refreshUI];
        }
        self.productID = nil;
    }

    statusLabel.text = statusString;
}

- (void)inventoryGroupUpdated {
    [self inventoryStatusChanged:[NSNumber numberWithInt:UAInventoryStatusLoaded]];
}

- (void)showLoading {
    loadingView.hidden = NO;
    activityView.hidden = NO;
    [activityView startAnimating];

    productTable.hidden = YES;

    if(self.searchDisplayController.active) {
        self.searchDisplayController.searchResultsTableView.hidden = YES;
        toolBar.hidden = YES;
    }
}

- (void)hideLoading {
    loadingView.hidden = YES;
    activityView.hidden = YES;
    [activityView stopAnimating];

    productTable.hidden = NO;

    if(self.searchDisplayController.active) {
        self.searchDisplayController.searchResultsTableView.hidden = NO;
        toolBar.hidden = NO;
    }
}

#pragma mark -
#pragma mark Search Methods

- (void)filterContentForSearchText:(NSString*)searchText {

    NSArray *productsArray = self.products;
    [filteredProducts removeAllObjects];
    int count = [productsArray count];
    for (int i = 0; i < count; i++) {
        UAProduct *product = [productsArray objectAtIndex:i];
        NSRange range = [product.title rangeOfString:searchText
                                             options:(NSCaseInsensitiveSearch
                                                      |NSDiacriticInsensitiveSearch
                                                      |NSWidthInsensitiveSearch)];
        if (range.location != NSNotFound) {
            [filteredProducts addObject:product];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.rowHeight = 80;
}

#pragma mark -
#pragma mark UI Action

- (IBAction)segmentAction:(id)sender {
    [self.productTable reloadData];
}

- (void)done:(id)sender {
    [UAStoreFront quitStoreFront];
}

- (void)updateAll {
    [UAStoreFront updateAllProducts];
}

- (void)restoreAll {
    NSString* okStr = UA_SF_TR(@"UA_OK");
    NSString* cancelStr = UA_SF_TR(@"UA_Cancel");
    NSString* restoreTitle = UA_SF_TR(@"UA_content_restore_title");
    NSString* restoreMsg = UA_SF_TR(@"UA_content_restore_question");

    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:restoreTitle
                                                           message:restoreMsg
                                                          delegate:self
                                                 cancelButtonTitle:cancelStr
                                                 otherButtonTitles:okStr, nil];
    [restoreAlert show];
    [restoreAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // OK Clicked
        [UAStoreFront restoreAllProducts];
    }
}

@end
