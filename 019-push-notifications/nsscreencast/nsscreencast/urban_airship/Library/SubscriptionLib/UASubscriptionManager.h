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

#import "UAGlobal.h"
#import "UAObservable.h"

@class UASubscriptionProduct;
@class UASubscriptionObserver;
@class UASubscriptionInventory;
@class UASubscriptionContent;
@class UASubscriptionDownloadManager;

#define SUBSCRIPTION_UI_CLASS @"UASubscriptionUI"

UA_VERSION_INTERFACE(SubscriptionVersion)

///---------------------------------------------------------------------------------------
/// @name Subscription Errors
///---------------------------------------------------------------------------------------

/** The error domain for transaction-related failures */
extern NSString * const UASubscriptionTransactionErrorDomain;

/** 
 * This value indicates that the transaction failed when the receipt failed to verify
 * with Apple's servers.
 */
extern NSString * const UASubscriptionReceiptVerificationFailure;

/** Error codes for the UASubscriptionTransactionErrorDomain error domain */
typedef enum _UASubscriptionTransactionErrorType {
    /** This error code indicates that the submitted receipt is invalid. */
    UASubscriptionReceiptVerificationFailedErrorType = 1,
    
    /** This error code indicates that the verification service could not be contacted. */
    UASubscriptionReceiptVerificationServiceFailedErrorType = 2
} UASubscriptionTransactionErrorType;

/** The error domain for Subscription REST API-related failures */
extern NSString * const UASubscriptionRequestErrorDomain;

// Error failure messages for use with inventoryUpdateFailedWithError:
/** This value indicates that the list of purchased products failed to load */
extern NSString * const UASubscriptionPurchaseInventoryFailure;

/** This value indicates that the list of available content failed to load */
extern NSString * const UASubscriptionContentInventoryFailure;

/** This value indicates that the list of available products failed to load */
extern NSString * const UASubscriptionProductInventoryFailure;



@protocol UASubscriptionUIProtocol
+ (void)displaySubscription:(UIViewController *)viewController
                   animated:(BOOL)animated;
+ (void)hideSubscription;
@end

/*
 * Important:
 * Since subscription and its products are created only once,
 * so same instance during one execution.
 * But contents will be reloaded once new product is purchased,
 * so contents' instance will be changed
 */
@protocol UASubscriptionManagerObserver <NSObject>
@optional
- (void)subscriptionWillEnterForeground;
- (void)subscriptionWillEnterBackground;

/**
 * The subscription, subscription product and content inventory has been updated.
 *
 * @param subscriptions The list of available subscriptions.
 */
- (void)subscriptionsUpdated:(NSArray *)subscriptions;

/**
 * The user's subscription purchase list has been updated.
 * 
 * @param subscriptions The array of subscriptions for which the user has purchased products.  
 */
- (void)userSubscriptionsUpdated:(NSArray *)subscriptions;

/** 
 * Inventory update callback.
 *
 * Called if an inventory update fails when retrieving purchase, product
 * or contents information from UA or Apple. If the error occurs when
 * requesting the inventory from Apple, the original StoreKit error will
 * be passed as the parameter. If the error occurs when contacting UA,
 * the error code will be an HTTP response code (or 0 if no response),
 * the failure URL will be available in the userInfo dictionary
 * using NSErrorFailingURLStringKey or NSURLErrorFailingURLStringErrorKey (4.0+)
 * and the localizedDescription will be one of:
 *       
 *       - UASubscriptionPurchaseInventoryFailure
 *       - UASubscriptionContentInventoryFailure
 *       - UASubscriptionProductInventoryFailure
 *
 * @param error The StoreKit or UA error
 */
- (void)inventoryUpdateFailedWithError:(NSError *)error;

- (void)downloadContentFinished:(UASubscriptionContent *)content;
- (void)downloadContentFailed:(UASubscriptionContent *)content;

/**
 * A product has been successfully purchased, including receipt verification.
 *
 * @param product The purchased product
 */
- (void)purchaseProductFinished:(UASubscriptionProduct *)product;

/** This method is called if a StoreKit purchase fails. The purchase may be
 * retried.
 *
 * @param product The UASubscriptionProduct
 * @param error The StoreKit error returned with the transaction or a UA error with
 * a UASubscriptionTransactionErrorDomain domain
 *
 */
- (void)purchaseProductFailed:(UASubscriptionProduct *)product withError:(NSError *)error;

/**
 * Called when StoreKit delivers a renewal transaction. These types of transactions are
 * are unique to autorenewables as they have a SKTransactionStateRestored state but are
 * delivered outside of the context of a standard restore process
 */
- (void)subscriptionProductRenewed:(UASubscriptionProduct *)product;

/**
 * This method is called when a restore process completes without error.
 *
 * @param productsRestored An array of the products for which receipts were
 *   found, nil if no autorenewables were found.
 *
 */
- (void)restoreAutorenewablesFinished:(NSArray *)productsRestored;

/**
 * This method is called when a restore fails due to a StoreKit error,
 * including cancellation.
 * 
 * @param error The StoreKit error passed back with the failed transaction.
 *
 */
- (void)restoreAutorenewablesFailedWithError:(NSError *)error;

/**
 * This is called when a specific autorenewable receipt verification fails due
 * to an invalid receipt or network issues. A success message may still follow
 * for other products.
 * 
 * @param product The product that failed during receipt verification.
 */
- (void)restoreAutorenewableProductFailed:(UASubscriptionProduct *)product;
@end

/**
 * This class provides the primary interface for interacting with the Urban Airship
 * subscription functionality.
 *
 * It provides support for both autorenewable and non-autorenewable subscriptions.
 *
 * Register a UASubscriptionManagerObserver to receive notifications when products,
 * subsriptions or their contents change.
 */
@interface UASubscriptionManager : UAObservable {
  @private
    UASubscriptionDownloadManager *downloadManager;
    UASubscriptionInventory *inventory;
    UASubscriptionObserver *transactionObserver;
    UASubscriptionProduct *pendingProduct;//should be deprecated
}

///---------------------------------------------------------------------------------------
/// @name Inventory
///---------------------------------------------------------------------------------------

/** The inventory of subscriptions (and their products and contents) */
@property (retain, readonly) UASubscriptionInventory *inventory;
@property (retain, nonatomic) UASubscriptionProduct *pendingProduct;//this should be deprecated

///---------------------------------------------------------------------------------------
/// @name Downloads
///---------------------------------------------------------------------------------------
@property (nonatomic, retain) UASubscriptionDownloadManager *downloadManager;

///---------------------------------------------------------------------------------------
/// @name Singleton
///---------------------------------------------------------------------------------------

/** 
 * Singleton initializer.
 * 
 * @returns The singleton instance.
 */
+ (UASubscriptionManager*)shared;
- (void)forceRelease;
// ^ The above singleton declarations were inlined for documentation purproses
// from SINGLETON_INTERFACE(UASubscriptionManager)

/**
 * Test whether the singleton has been initialized.
 * 
 * @returns YES if initialized, otherwise NO
 */
+ (BOOL)initialized;

///---------------------------------------------------------------------------------------
/// @name UI and Initialization
///---------------------------------------------------------------------------------------

- (Class)uiClass;
+ (void)useCustomUI:(Class)customUIClass;
+ (void)displaySubscription:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)hideSubscription;
+ (void)land;

/**
 * Set a custom download directory, creating it if necessary. Creates a
 * product ID subdirectory if the product ID is specified in the
 * Urban Airship content information.
 *
 * The default directory is defined as kUADownloadDirectory:
 * <library directory>/ua/downloads/
 *
 * @param path The custom download directory (with trailing slash)
 * @returns YES if the path was successfully set (exists or created)
 */
+ (BOOL)setDownloadDirectory:(NSString *)path;

/**
 * Set a custom download directory. Optionally creates a product ID subdirectory if
 * the product ID is specified in the Urban Airship content information.
 *
 * The default directory is defined as kUADownloadDirectory:
 * <library directory>/ua/downloads/
 *
 * @param path The custom download directory (with trailing slash)
 * @param makeSubdir If YES, creates a subdirectory named with the content key
 * *OR* the product ID, if available
 * @returns YES if the path was successfully set (exists or created)
 */
+ (BOOL)setDownloadDirectory:(NSString *)path withProductIDSubdir:(BOOL)makeSubdir;

// Public purchase and restore methods

///---------------------------------------------------------------------------------------
/// @name Purchase and Restore Subscriptions
///---------------------------------------------------------------------------------------

/**
 * Purchase a subscription product.
 * 
 * Register a UASubscriptionManagerObserver to receive status updates for this process.
 *
 * @param product The subscription product to purchase
 */
- (void)purchase:(UASubscriptionProduct *)product;

/**
 * Purchase a subscription product.
 * 
 * Register a UASubscriptionManagerObserver to receive status updates for this process.
 *
 * @param product The product ID to purchase
 */
- (void)purchaseProductWithId:(NSString *)productId;

// The following methods (pending subs) should be deprecated
- (void)setPendingSubscription:(UASubscriptionProduct *)product;
- (void)purchasePendingSubscription;

/**
 * Restores all autorenewable purchases for this user.
 *
 * This triggers a StoreKit restore process, which requests receipts for all
 * the autorenewable subscription products that this user has ever purchased.
 *
 * Once received, the receipts are submitted to Urban Airship so that the appropriate
 * access may be granted. If the user is restoring purchases from another device,
 * this device's user will be merged into the original UA user based on their iTunes account.
 *
 * Register a UASubscriptionManagerObserver to receive status updates for this process.
 */
- (void)restoreAutorenewables;

/**
 * Loads the product inventory, the available content and the user's purchases. 
 * 
 * This is an asynchronous task. Register a UASubscriptionManagerObserver to
 * receive status updates for this process.
 */
- (void)loadSubscription;

// Private
@property (retain, readonly) UASubscriptionObserver *transactionObserver;

// Private observer notifiers - do not use
- (void)enterForeground;
- (void)enterBackground;
- (void)subscriptionWillEnterForeground;
- (void)subscriptionWillEnterBackground;
- (void)subscriptionsUpdated:(NSArray *)subscriptions;
- (void)userSubscriptionsUpdated:(NSArray *)userSubscritions;
- (void)inventoryUpdateFailedWithError:(NSError *)error;
- (void)purchaseProductFinished:(UASubscriptionProduct *)product;
- (void)purchaseProductFailed:(UASubscriptionProduct *)product withError:(NSError *)error;
- (void)downloadContentFinished:(UASubscriptionContent *)content;
- (void)downloadContentFailed:(UASubscriptionContent *)content;
- (void)restoreAutorenewablesFinished:(NSArray *)productsRestored;
- (void)restoreAutorenewableProductFailed:(UASubscriptionProduct *)product;
- (void)restoreAutorenewablesFailedWithError:(NSError *)error;

@end
