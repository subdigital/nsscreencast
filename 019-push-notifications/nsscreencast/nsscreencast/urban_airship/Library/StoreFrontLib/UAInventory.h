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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "UAStoreFront.h"
#import "UAObservable.h"

@class UA_ASIHTTPRequest;
@class UA_Reachability;
@class UAProduct;

/**
 * This class manages the IAP inventory.
 */
@interface UAInventory : UAObservable<SKProductsRequestDelegate> {

  @private
    NSMutableDictionary *products;
    NSMutableArray *keys;
    NSMutableArray *sortedProducts;
    NSMutableArray *updatedProducts;
    NSMutableArray *installedProducts;

    UA_Reachability *hostReach;
    UAInventoryStatus status;
    NSUInteger reloadCount;

    NSString *orderBy;
    BOOL orderAscending;

    NSString *purchasingProductIdentifier;
}

/**
 * The the inventory's status, as a UAInventoryStatus enum value.
 */
@property (nonatomic, assign) UAInventoryStatus status;
/**
 * The key used to determine the inventory's sort order.
 */
@property (nonatomic, retain) NSString *orderBy;

@property (nonatomic, retain) NSString *purchasingProductIdentifier;

/**
 * Loads the inventory.
 */
- (void)loadInventory;
- (void)groupInventory;
- (void)resetReloadCount;
- (void)reloadInventory;

/**
 * Returns a subset of products corresponding to a particular product type.
 * @param type The UAProductType enum value corresponding to the product type.
 * @return A subset of products as an NSArray.
 */
- (NSArray *)productsForType:(UAProductType)type;
/**
 * Returns the UAProduct instance from the inventory that corresponds to a particular identifier.
 * @param productId The associated product identifier.
 * @return A UAProduct instance.
 */
- (UAProduct *)productWithIdentifier:(NSString *)productId;
/**
 * Checks whether the inventory contains a particular product by identifier.
 * @param productId The product identifier.
 * @return YES if the associated product is present in the inventory, NO otherwise.
 */
- (BOOL)hasProductWithIdentifier:(NSString *)productId;

- (UAProduct *)productAtIndex:(int)index;

/**
 * Sets the product display order.
 * @param key A key constant that determines the sort order.
 * @param ascending A BOOL indicating whether to sort in ascending order.
 */
- (void)setOrderBy:(NSString *)key ascending:(BOOL)ascending;

- (void)sortInventory;

/**
 * Purchases a particular product by identifier.
 * @param productIdentifier The product's associated identifier.
 */
- (void)purchase:(NSString *)productIdentifier;
/**
 * Purchases all updated products.
 */
- (void)updateAll;

+ (NSString *)localizedPrice:(SKProduct *)product;

@end