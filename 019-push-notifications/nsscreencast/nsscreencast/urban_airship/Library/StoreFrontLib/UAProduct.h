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

#import "UAObservable.h"
#import "UA_ASIProgressDelegate.h"

@class UAAsyncImageView;

/**
 * An enum of the possible product states.
 */
typedef enum UAProductStatus {
    /**
     * The product has not been purchased.
     */
    UAProductStatusUnpurchased = 0,
    /**
     * The product is currently being purchased.
     */
    UAProductStatusPurchasing,
    /**
     * The product's receipt is being verified.
     */
    UAProductStatusVerifyingReceipt,
    /**
     * The product is purchased, but a download is still pending.
     */
    UAProductStatusPurchased,
    /**
     * The product is currently downloading.
     */
    UAProductStatusDownloading,
    /**
     * The product is currently decompressing.
     */
    UAProductStatusDecompressing, // transient state 
    /**
     * The product is installed.
     */
    UAProductStatusInstalled,
    /**
     * The product is installed but an update is available.
     */
    UAProductStatusHasUpdate
} UAProductStatus;

/**
 * This class represents a product in the IAP inventory.  Instances of
 * UAProduct should be considered ephemeral, as they are instantiated
 * when the inventory is loaded.
 */
@interface UAProduct : UAObservable <NSCopying, UA_ASIProgressDelegate> {
  @private
    NSString *productIdentifier;
    NSURL *previewURL;
    UAAsyncImageView *preview;
    NSURL *iconURL;
    UAAsyncImageView *icon;
    NSURL *downloadURL;
    int revision;
    double fileSize;
    NSString *price;
    NSDecimalNumber *priceNumber;
    NSString *productDescription;
    NSString *title;
    NSString *receipt;
    SKProduct *skProduct;
    BOOL isFree;

    UAProductStatus status;

    // for downloading status
    float progress;
    SKPaymentTransaction *transaction;
}

/**
 * The associated SKProduct instance.
 */
@property (nonatomic, retain) SKProduct *skProduct;
/**
 * The product identifier string.
 */
@property (nonatomic, retain) NSString *productIdentifier;
/**
 * The preview image URL.
 */
@property (nonatomic, retain) NSURL *previewURL;
/**
 * The preview image view.
 */
@property (nonatomic, retain) UAAsyncImageView *preview;
/**
 * The icon URL.
 */
@property (nonatomic, retain) NSURL *iconURL;
/**
 * The icon image view.
 */
@property (nonatomic, retain) UAAsyncImageView *icon;
/**
 * The download URL.
 */
@property (nonatomic, retain) NSURL *downloadURL;
/**
 * The revision number.
 */
@property (nonatomic, assign) int revision;
/**
 * The file size in bytes.
 */
@property (nonatomic, assign) double fileSize;
/**
 * The price as a string.
 */
@property (nonatomic, retain) NSString *price;
/**
 * The price as an NSDecimalNumber.
 */
@property (nonatomic, retain) NSDecimalNumber *priceNumber;
/**
 * The product description.
 */
@property (nonatomic, retain) NSString *productDescription;
/**
 * The product title.
 */
@property (nonatomic, retain) NSString *title;
/**
 * The purchase receipt, if present.
 */
@property (nonatomic, copy) NSString *receipt;
/**
 * A BOOL indicating whether the product is free.
 */
@property (nonatomic, assign) BOOL isFree;
/**
 * The current status of the product, as a UAProductStatus enum value.
 */
@property (nonatomic, assign) UAProductStatus status;
/**
 * The product's download progress as a float between 0 and 1.
 */
@property (nonatomic, assign) float progress;
/**
 * The product's associated SKPaymentTranscation.
 */
@property (nonatomic, assign) SKPaymentTransaction *transaction;

- (id)init;
+ (UAProduct *)productFromDictionary:(NSDictionary *)item;
- (NSComparisonResult)compare:(UAProduct *)product;
- (void)resetStatus;
/**
 * Indicates whether the product has an update available.
 * @return YES if an update is available, NO otherwise.
 */
- (BOOL)hasUpdate;

- (void)setProgress:(float)_progress;

@end


