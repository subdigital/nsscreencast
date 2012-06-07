/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
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

#import <Foundation/Foundation.h>

#import "UASubscriptionManager.h"
#import "UASubscriptionProduct.h"
#import "UASubscriptionInventory.h"
#import "UAGlobal.h"
#import "UAUser.h"
#import "UASubscriptionUI.h"

#import "UASubscriptionSettingsViewController.h"
#import "UASubscriptionRootViewController.h"

@implementation UASubscriptionRootViewController


- (void)dealloc {
    
	RELEASE_SAFELY(productsTable);
    RELEASE_SAFELY(activity);
    RELEASE_SAFELY(settingsViewController);
    
	[super dealloc];
}


- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(quit)] autorelease];
	
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:UA_SS_TR(@"UA_Setting")
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(loadSettingsView)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:UA_SS_TR(@"UA_Restore")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(restore)] autorelease];

    [segment setTitle:UA_SS_TR(@"UA_All") forSegmentAtIndex:0];
    [segment setTitle:UA_SS_TR(@"UA_Subscribed") forSegmentAtIndex:1];

    [[UASubscriptionManager shared] addObserver:self];
    [self loadAllSubscriptions];
}

- (void)viewWillUnload {
    [[UASubscriptionManager shared] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [productsTable deselectRowAtIndexPath:[productsTable indexPathForSelectedRow] animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)quit {
    [UASubscriptionManager hideSubscription];
}


/*
 * Switch UI between loading and display
 */
- (void)setLoading:(BOOL)isLoading {
    if (isLoading) {
        [activity startAnimating];
        productsTable.hidden = YES;
    } else {
        [activity stopAnimating];
        [productsTable reloadData];
        productsTable.hidden = NO;
    }
}


- (void)reloadTableWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    productsTable.delegate = delegate;
    productsTable.dataSource = delegate;
    [self setLoading:![UASubscriptionManager shared].inventory.hasLoaded];
}


- (void)loadAllSubscriptions {
    if (allProductsDelegate == nil) {
        allProductsDelegate = [[UASubscriptionTableViewDelegateAllProducts alloc] initWithRootViewController:self];
    }
    [self reloadTableWithDelegate:allProductsDelegate];
}


- (void)loadPurchasedSubscriptions {
    if (purchasedProductsDelegate == nil) {
        purchasedProductsDelegate = [[UASubscriptionTableViewDelegatePurchasedProducts alloc] initWithRootViewController:self];
    }
    [self reloadTableWithDelegate:purchasedProductsDelegate];
}


- (IBAction)segmentAction:(id)sender {
    if (segment.selectedSegmentIndex == SubscriptionTypeAll) {
        [self loadAllSubscriptions];
    } else if (segment.selectedSegmentIndex == SubscriptionTypePurchased) {
        [self loadPurchasedSubscriptions];
    }
}


- (void)loadSettingsView {
    if (settingsViewController == nil) {
        settingsViewController = [[UASubscriptionSettingsViewController alloc]
                                  initWithNibName:@"UASubscriptionSettingsViewController"
                                  bundle:nil];
    }
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)restore {
    [[UASubscriptionManager shared] restoreAutorenewables];
}


#pragma mark -
#pragma mark UASubscriptionManagerObserver

- (void)subscriptionWillEnterForeground {
    UALOG(@"subscriptionWillEnterForeground");
    
    if (self.navigationController.topViewController != self) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    if (segment.selectedSegmentIndex == SubscriptionTypeAll)
        [self segmentAction:segment];
    else
        segment.selectedSegmentIndex = SubscriptionTypeAll;
}

- (void)subscriptionWillEnterBackground {
    UALOG(@"subscriptionWillEnterBackground");
}

- (void)userSubscriptionsUpdated:(NSArray *)userSubscriptions {
    UALOG(@"Observer notified : userSubscriptionsUpdated");
    if (segment.selectedSegmentIndex == SubscriptionTypePurchased) {
        [self setLoading:NO];
    }
}


- (void)subscriptionsUpdated:(NSArray *)subscriptions {
    UALOG(@"Observer notified : subscriptionsUpdated");
    if (segment.selectedSegmentIndex == SubscriptionTypeAll) {
        [self setLoading:NO];
    }
}

- (void)inventoryUpdateFailedWithError:(NSError *)error {
    UALOG(@"Inventory update failed with error code %d and domain %@ and description: %@",error.code, error.domain, error.localizedDescription);
    if ([error.domain isEqualToString:UASubscriptionRequestErrorDomain]) {
        NSDictionary *userInfo = error.userInfo;
        UALOG(@"URL Failed: %@", [userInfo objectForKey:NSErrorFailingURLStringKey]);
    }
}

- (void)subscriptionProductRenewed:(UASubscriptionProduct *)product {
    UALOG(@"Subscription product renewed: %@", product.title);
}

- (void)restoreAutorenewablesFinished:(NSArray *)productsRestored {
    UALOG(@"Autorenewable restore finished. %d products restored.",[productsRestored count]);
}

- (void)restoreAutorenewablesFailedWithError:(NSError *)error {
    UALOG(@"Autorenewable restore failed with error code %d and reason=%@. Try again later.", [error code], [error localizedDescription]);
}

- (void)restoreAutorenewableProductFailed:(UASubscriptionProduct *)product {
    UALOG(@"Autorenewable restore failed for product ID %@", product.productIdentifier);
}

- (void)purchaseProductFailed:(UASubscriptionProduct *)failedProduct withError:(NSError *)error {
    UALOG(@"Purchase product failed with error code %d and reason=%@. Try again later.", [error code], [error localizedDescription]);
}

@end
