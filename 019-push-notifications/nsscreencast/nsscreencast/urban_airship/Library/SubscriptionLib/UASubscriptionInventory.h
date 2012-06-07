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

#import "UAObservable.h"

@class UAProductInventory;
@class UAContentInventory;
@class UASubscriptionProduct;
@class UASubscriptionContent;
@class UASubscription;
@class UASubscriptionDownloadManager;

@class SKPaymentTransaction;


/**
 * This class provides access to the full inventory
 * of subscriptions offered for sale in this application.
 */
@interface UASubscriptionInventory : UAObservable {
  @private
    NSMutableArray *subscriptions;
    NSMutableArray *userSubscriptions;
    NSMutableDictionary *subscriptionDict;
    NSArray *userPurchasingInfo;

    UAProductInventory *products;
    UAContentInventory *contents;

    BOOL userPurchasingInfoLoaded;
    BOOL productsLoaded;
    BOOL contentsLoaded;
    BOOL hasLoaded;

    BOOL hasActiveSubscriptions;
    NSDate *serverDate;
}

///---------------------------------------------------------------------------------------
/// @name Access Subscription Inventory
///---------------------------------------------------------------------------------------

/** YES if the inventory has successfully loaded, otherwise NO */
@property (nonatomic, assign, readonly) BOOL hasLoaded;

/** The array of subscriptions the user has purchased */
@property (nonatomic, retain, readonly) NSMutableArray *userSubscriptions;

/** The array of all available subscriptions */
@property (nonatomic, retain, readonly) NSMutableArray *subscriptions;

/**
 * The time of the last purchased product update. Useful for preventing users from setting back
 * their clocks to access expired content.
 */
@property (nonatomic, retain) NSDate *serverDate;

///---------------------------------------------------------------------------------------
/// @name Load Inventory and Purchases
///---------------------------------------------------------------------------------------

/** Load all products, content and purchases */
- (void)loadInventory;

/** Load all products */
- (void)loadProducts;

/** Load the content inventory and all of the user's purchases. */
- (void)loadPurchases;

///---------------------------------------------------------------------------------------
/// @name Purchase and Download
///---------------------------------------------------------------------------------------

/**
 * Purchase a subscription product.
 * 
 * @param product The product to purchase
 */
- (void)purchase:(UASubscriptionProduct *)product;

/**
 * Check the UA receipt verification response.
 *
 * @param responseString The receipt validatation response string (JSON).
 *
 * @return YES if the receipt was validated, otherwise NO
 */
+ (BOOL)isReceiptValid:(NSString *)responseString;

/**
 * Download subscription content.
 *
 * @param content The content to download
 */
- (void)download:(UASubscriptionContent *)content;

///---------------------------------------------------------------------------------------
/// @name Query Subscriptions
///---------------------------------------------------------------------------------------

/**
 * Return the subscription content matching a particular content key.
 * @param contentKey The content key.
 * @return A matching UASubscriptionContent instance.
 */
- (UASubscriptionContent *)contentForKey:(NSString *)contentKey;
/**
 * Return the subscription matching a particular subscription key.
 * @param subscriptionKey The subscription key.
 * @return A matching UASubscription instance.
 */
- (UASubscription *)subscriptionForKey:(NSString *)subscriptionKey;
/**
 * Return the subscription matching a particular subscription product.
 * @param product The subscription product.
 * @return A matching UASubscription instance.
 */
- (UASubscription *)subscriptionForProduct:(UASubscriptionProduct *)product;
/**
 * Return the subscription matching a particular instance of subscription content.
 * @param content The subscription content.
 * @return A matching UASubscription instance.
 */
- (UASubscription *)subscriptionForContent:(UASubscriptionContent *)content;
/**
 * Check whether the inventory contains a particular product by identifier.
 * @param productID The product identifier.
 * @return YES if the inventory contains the associated product, NO otherwise.
 */
- (BOOL)containsProduct:(NSString *)productID;
/**
 * Return the subscription product matching a particular subscription product key.
 * @param productKey The subscription product key.
 * @return A matching UASubscriptionProduct.
 */
- (UASubscriptionProduct *)productForKey:(NSString *)productKey;

//Private
- (void)subscriptionTransactionDidComplete:(SKPaymentTransaction *)transaction;

- (void)productInventoryUpdated;
- (void)contentInventoryUpdated;

- (void)setUserPurchaseInfo:(NSDictionary *)purchaseInfo;

@end