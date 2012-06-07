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

#import "UAGlobal.h"

@protocol UAStoreFrontAlertProtocol;
@protocol UAStoreFrontDelegate;

@class UAProduct;

#define STOREFRONT_UI_CLASS @"UAStoreFrontUI"

/**
 * A string constant indicating a display order by title.
 */
UIKIT_EXTERN NSString * const UAContentsDisplayOrderTitle;
/**
 * A string constant indicating a display order by product identifier.
 */
UIKIT_EXTERN NSString * const UAContentsDisplayOrderID;
/**
 * A string constant indicating a display order by price.
 */
UIKIT_EXTERN NSString * const UAContentsDisplayOrderPrice;

/**
 * An enum of the possible inventory states.
 */
typedef enum {
    /**
     * Indicates that the inventory has not yet been loaded.
     */
    UAInventoryStatusUnloaded = 0,
    /**
     * Indicates that purchase is disabled.
     */
    UAInventoryStatusPurchaseDisabled,
    /**
     * Indicates that the inventory is currently loading.
     */
    UAInventoryStatusDownloading,
    /**
     * Indicates that the inventory is currently retrieving
     * pricing information from Apple.
     */
    UAInventoryStatusApple,
    /**
     * Indicates that the inventory is loaded.
     */
    UAInventoryStatusLoaded,
    /**
     * Indicates that the inventory failed to load.
     */
    UAInventoryStatusFailed,
} UAInventoryStatus;

/**
 * An enum representing different subsets of
 * products that can be queried.
 */
typedef enum {
    /**
     * All products.
     */
    ProductTypeAll = 0,
    /**
     * Only installed products.
     */
    ProductTypeInstalled = 1,
    /**
     * Only products that have updates available.
     */
    ProductTypeUpdated = 2,
    /**
     * All products, unsorted.
     */
    ProductTypeOrigin = 10
} UAProductType;

UA_VERSION_INTERFACE(StoreFrontVersion)

/**
 * Implementers of this protocol will receive callbacks
 * related to the IAP UI display.
 */
@protocol UAStoreFrontUIProtocol
@required
/**
 * Called when the IAP UI should be quit.
 */
+ (void)quitStoreFront;
/**
 * Called when the IAP UI should be displayed.
 * @param viewController The calling view controller.
 * @param animated Indicates whether the transition to the IAP UI should be animated.
 */
+ (void)displayStoreFront:(UIViewController *)viewController animated:(BOOL)animated;
/**
 * Called when IAP needs to display an alert
 * @return An alert handler conforming to the UAStoreFrontAlertProtocol.
 */
+ (id<UAStoreFrontAlertProtocol>)getAlertHandler;
@end

/**
 * Implementers of this protocol will receive callbacks
 * related to inventory state changes
 */
@protocol UAStoreFrontObserverProtocol
@optional
/**
 * Called when the restore status has changed
 * @param inRestoring A boolean value wrappen in a NSNumber indicating whether
 * a restore is in progress.
 */
- (void)restoreStatusChanged:(NSNumber *)inRestoring;
/** 
 * Called when the inventory groups are updated.
 */
- (void)inventoryGroupUpdated;
/** 
 * Called when the inventory status has changed.
 * @param status A UAInventoryStatus enum value wrapped in an NSNumber.
 */
- (void)inventoryStatusChanged:(NSNumber *)status;
/**
 * Called when thet status of any one of the products in the inventory has
 * changed state.
 * @param status A corresponding UAProductStatus enum value wrapped in an NSNumber.
 */
- (void)inventoryProductsChanged:(NSNumber *)status;
@end

/**
 * Implementers of this protocol will receive callbacks
 * from UAProduct instances when their state changes,
 * if the implementer has registered as an observer.
 */
@protocol UAProductObserverProtocol
@optional
/**
 * Called when the product's status has changed.
 * @param status A UAProductStatus enum value wrapped in an NSNumber.
 */
- (void)productStatusChanged:(NSNumber*)status;
/**
 * Called periodically when the product's download progress has updated.
 * @param a floating point progress value between 0 and 1, wrapped in an NSNumber.
 */
- (void)productProgressChanged:(NSNumber*)progress;
@end

@class UAInventory;
@class UAStoreKitObserver;
@class UAStoreFrontDownloadManager;

/**
 * This singleton is the primary interface to IAP.
 */
@interface UAStoreFront : NSObject {
  @private
    UAStoreKitObserver *sfObserver;
    UAInventory *inventory;
    UAStoreFrontDownloadManager *downloadManager;

    NSObject<UAStoreFrontDelegate> *delegate;
    NSMutableDictionary *purchaseReceipts;
}

/**
 * The StoreKit observer for IAP.
 */
@property (nonatomic, retain, readonly) UAStoreKitObserver *sfObserver;
/**
 * The download manager for IAP.
 * @return A UAStoreFrontDownloadManager instance.
 */
@property (nonatomic, retain, readonly) UAStoreFrontDownloadManager* downloadManager;
/**
 * A delegate implementing the UAStoreFrontDelegate protocol.
 * @return An object implementing the UAStoreFrontDelegate protocol.
 */
@property (nonatomic, assign) NSObject<UAStoreFrontDelegate> *delegate;
/**
 * The IAP inventory.
 * @return A UAInventory instance.
 */
@property (nonatomic, retain) UAInventory *inventory;
/**
 *The local store of of purchase receipts.
 * @return an NSMutableDictionary mapping product identifiers to receipt dictionaries.
 */
@property (nonatomic, retain) NSMutableDictionary *purchaseReceipts;

SINGLETON_INTERFACE(UAStoreFront)

/**
 * Test whether the singleton has been initialized.
 * 
 * @returns YES if initialized, otherwise NO
 */
+ (BOOL)initialized;

/**
 * Sets a custom UI class for IAP to use.
 * @param customUIClass A class implementing the UAStoreFrontUIProtocol.
 */
+ (void)useCustomUI:(Class)customUIClass;
/**
 * Quits the IAP UI.
 */
+ (void)quitStoreFront;

/**
 * Displays the IAP UI.
 * @param viewController The calling view controller.
 * @param animated A boolean indicating whether the transition should be animated.
 */
+ (void)displayStoreFront:(UIViewController *)viewController animated:(BOOL)animated;
/**
 * Displays the IAP UI.
 * @param viewController The calling view controller.
 * @param ID The identifier of the product to display.
 * @param animated A boolean indicating whether the transition should be animated.
 */
+ (void)displayStoreFront:(UIViewController *)viewController withProductID:(NSString *)ID animated:(BOOL)animated;

/**
 * Sets the display order of products in the inventory.
 * The default is order by product ID, descending.
 * @param key A display order key constant.
 */
+ (void)setOrderBy:(NSString *)key;
/**
 * Sets the display order of products in the inventory.
 * The default is order by product ID, descending.
 * @param key A display order key constant.
 * @param ascending A boolean indicating whether to sort in ascending order.
 */
+ (void)setOrderBy:(NSString *)key ascending:(BOOL)ascending;

/**
 * Directly purchases a specific product.
 * @param productIdentifier The identifier for the product to be purchased.
 */
+ (void)purchase:(NSString *)productIdentifier;

/**
 * Cleanup routine called by UAirship when tearing down the library.
 * You should not ordinarily call this method directly.
 */
+ (void)land;

/**
 * Registers an observer for inventory and payment callbacks.
 * @param observer An object implementing the UAStoreFrontObserver protocol.
 */
+ (void)registerObserver:(id)observer;
/**
 * Unregisters a previously registered observer.
 * @param observer An object implementing the UAStoreFrontObserver protocol, which was previously registered.
 */
+ (void)unregisterObserver:(id)observer;

/**
 * Adds a receipt for a product instance
 * @param product The product whose receipt should be added.
 */
- (void)addReceipt:(UAProduct *)product;
/**
 * Returns YES if there is a receipt for the product in question, NO otherwise.
 * @param product The product in question.
 * @return A BOOL indicating whether the local receipt store has a receipt associated with the product.
 */
- (BOOL)hasReceipt:(UAProduct *)product;
/**
 * Returns YES if a directory exists at either of the passed path strings.
 * @param path A directory path as an NSString.
 * @param oldPath A directory path as an NSString.
 * @return a BOOL indicating whether either directory path exists.
 */
- (BOOL)directoryExistsAtPath:(NSString *)path orOldPath:(NSString *)oldPath;
/**
 * Sets the download directory.
 * @param path A directory path as an NSString.
 * @return A BOOL indicating whether the operation was successful.
 */
+ (BOOL)setDownloadDirectory:(NSString *)path;
/**
 * Sets the download directory.
 * @param path A directory path as an NSString.
 * @param makeSubdir A BOOL indicating whether to create a subdirectory named after the product identifier.
 * @return A BOOL indicating whether the operation was successful.
 */
+ (BOOL)setDownloadDirectory:(NSString *)path withProductIDSubdir:(BOOL)makeSubdir;
/**
 * Returns the UI class IAP is using.
 * @return A Class object representing the UI class IAP is using.
 */
- (Class)uiClass;

/**
 * Loads the inventory.
 */
+ (void)loadInventory;
/**
 * Resets and loads the inventory.
 */
+ (void)resetAndLoadInventory;
/**
 * Reloads the inventory if it has previously failed.
 */
+ (void)reloadInventoryIfFailed;

/**
 * Returns an array of products corresponding to a UAProductType enum.
 * @param type A UAProduct type enum expressing the subset of products desired.
 * @return A subset of products as an NSArray.
 */
+ (NSArray *)productsForType:(UAProductType)type;
/**
 * Purchases all updated products.
 */
+ (void)updateAllProducts;
/**
 * Restores all products.
 */
+ (void)restoreAllProducts;

@end
