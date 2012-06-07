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

#import "UASubscriptionTableViewDelegate.h"
#import "UASubscriptionProductCell.h"
#import "UAViewUtils.h"
#import "UASubscription.h"
#import "UASubscriptionInventory.h"
#import "UASubscriptionProductDetailViewController.h"
#import "UASubscriptionContentsViewController.h"

@implementation UASubscriptionTableViewDelegate

- (void)dealloc {
    RELEASE_SAFELY(cell_uniq_id);
    RELEASE_SAFELY(detailViewController);
    [super dealloc];
}

- (id)initWithRootViewController:(UIViewController *)aRootViewController {
    if (!(self = [super init]))
        return nil;

    rootViewController = aRootViewController;
    cell_uniq_id = @"SubscriptionProductTableViewCell";
    return self;
}

- (NSArray *)productsForSection:(NSInteger)section {
    return nil;
}

- (UASubscriptionProduct *)productAtIndexPath:(NSIndexPath *)indexPath {
    return [[self productsForSection:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [subscriptions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self productsForSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[subscriptions objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UASubscriptionProductCell *cell = (UASubscriptionProductCell *)[tableView dequeueReusableCellWithIdentifier:cell_uniq_id];
    if (cell == nil) {
        cell = [[[UASubscriptionProductCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cell_uniq_id] autorelease];
        [UAViewUtils roundView:cell.iconContainer borderRadius:10 borderWidth:1 color:[UIColor darkGrayColor]];
    }
    cell.product = [self productAtIndexPath:indexPath];

    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [rootViewController.navigationController pushViewController:detailViewController animated:YES];
}

@end


@implementation UASubscriptionTableViewDelegateAllProducts

- (id)initWithRootViewController:(UIViewController *)aRootViewController {
    if (!(self = [super initWithRootViewController:aRootViewController]))
        return nil;

    subscriptions = [UASubscriptionManager shared].inventory.subscriptions;
    return self;
}

- (NSArray *)productsForSection:(NSInteger)section {
    //SLOW!
    return [[subscriptions objectAtIndex:section] availableProducts];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (detailViewController == nil) {
        detailViewController = [[UASubscriptionProductDetailViewController alloc]
                                initWithNibName:@"UASubscriptionProductDetailView"
                                bundle:nil];
    }
    [((UASubscriptionProductDetailViewController *)detailViewController) setProduct:[self productAtIndexPath:indexPath]];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end


@implementation UASubscriptionTableViewDelegatePurchasedProducts

- (id)initWithRootViewController:(UIViewController *)aRootViewController {
    if (!(self = [super initWithRootViewController:aRootViewController]))
        return nil;

    subscriptions = [UASubscriptionManager shared].inventory.userSubscriptions;
    return self;
}

- (NSArray *)productsForSection:(NSInteger)section {
    return [[ [[subscriptions objectAtIndex:section] purchasedProducts] reverseObjectEnumerator] allObjects];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (detailViewController == nil) {
        detailViewController = [[UASubscriptionContentsViewController alloc]
                                     initWithNibName:@"UASubscriptionContentsViewController"
                                     bundle:nil];
    }
    ((UASubscriptionContentsViewController *)detailViewController).subscriptionKey = [[subscriptions objectAtIndex:indexPath.section] key];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
