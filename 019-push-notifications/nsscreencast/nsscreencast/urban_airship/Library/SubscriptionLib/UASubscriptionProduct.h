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

@class SKProduct;

/**
 * An enum representing the different possible susbscription product types.
 */
typedef enum _UASubscriptionProductType {
    /**
     * Legacy subscription proucts.
     */
    UASubscriptionProductTypeLegacy = 0,
    /**
     * Autorenewables.
     */
    UASubscriptionProductTypeAutorenewable = 1,
    /**
     * Free subscription products.
     */
    UASubscriptionProductTypeFree = 2
} UASubscriptionProductType;

/**
 * An enum representing the different possible autorenewable durations.
 */
typedef enum _UAAutorenewableDuration {
    /**
     * No duration.
     */
    UAAutorenewableDurationNone = 0,
    /**
     * Seven days.
     */
    UAAutorenewableDuration7Days = 1,
    /**
     * One month.
     */
    UAAutorenewableDuration1Month = 2,
    /**
     * Two months.
     */
    UAAutorenewableDuration2Months = 3,
    /**
     * Three months.
     */
    UAAutorenewableDuration3Months = 4,
    /**
     * Six months.
     */
    UAAutorenewableDuration6Months = 5,
    /**
     * One year.
     */
    UAAutorenewableDuration1Year = 6
} UAAutorenewableDuration;

/**
 * This class represents a subscription product available for purchase.
 */
@interface UASubscriptionProduct : NSObject {
  @private
    NSString *productIdentifier;
    NSString *subscriptionKey;
    NSString *subscriptionName;
    NSURL *subscribeURL;
    NSURL *previewURL;
    NSURL *iconURL;
    int duration;
    
    UASubscriptionProductType productType;
    UAAutorenewableDuration autorenewableDuration;

    //property from SKProduct
    SKProduct *skProduct;
    NSString *title;
    NSString *productDescription;
    NSString *price;
    NSDecimalNumber *priceNumber;

    // For purchased product
    BOOL purchased;
    NSDate *startDate;
    NSDate *endDate;

    // Flag to indicate if the product is in the app store
    BOOL isForSale;

    // For UI
    BOOL isPurchasing;
}

///---------------------------------------------------------------------------------------
/// @name Product Info
///---------------------------------------------------------------------------------------

/**
 * The product identifier.
 */
@property (nonatomic, retain) NSString *productIdentifier;
/**
 * The URL used to subscribe to this product.
 */
@property (nonatomic, retain) NSURL *subscribeURL;
/**
 * The URL for this product's preview image.
 */
@property (nonatomic, retain) NSURL *previewURL;
/**
 * The URL for this product's icon.
 */
@property (nonatomic, retain) NSURL *iconURL;

/** 
 * The duration in days.
 * 
 * This value is set in the UA web site for non-autorenewables, but
 * for autorenewables it is estimated based on autorenewableDuration
 * for sorting purposes.
 */
@property (nonatomic, assign) int duration;
/**
 * The subscription key.
 */
@property (nonatomic, retain) NSString *subscriptionKey;
/**
 * The subscription name.
 */
@property (nonatomic, retain) NSString *subscriptionName;

/** 
 * The SKProduct (from Apple) that this product provides. nil if the product is not for sale
 */
@property (nonatomic, retain) SKProduct *skProduct;
/**
 * The title.
 */
@property (nonatomic, retain) NSString *title;
/**
 * The description.
 */
@property (nonatomic, retain) NSString *productDescription;
/**
 * The price represented as an NSString.
 */
@property (nonatomic, retain) NSString *price;
/**
 * The price represented as an NSDecimalNumber.
 */
@property (nonatomic, retain) NSDecimalNumber *priceNumber;
/**
 * YES if the product is currently being purchased, NO otherwise.
 */
@property (nonatomic, assign) BOOL isPurchasing;

///---------------------------------------------------------------------------------------
/// @name Purchase Info
///---------------------------------------------------------------------------------------

/** This flag is set if this product is a member of the [UASubscription purchasedProducts] array.*/
@property (nonatomic, assign) BOOL purchased;

/**
 * The start date for this specific purchased product's time slice.
 *
 * This value is only set if this product is a member of the [UASubscription purchasedProducts] array.
 */
@property (nonatomic, retain) NSDate *startDate;

/**
 * The end date for this specific purchased product's time slice.
 *
 * This value is only set if this product is a member of the [UASubscription purchasedProducts] array.
 */
@property (nonatomic, retain) NSDate *endDate;

/** @return YES if the product is listed for sale in iTunes Connect, otherwise NO */
@property (nonatomic, assign) BOOL isForSale;

///---------------------------------------------------------------------------------------
/// @name Autorenewable Info
///---------------------------------------------------------------------------------------

/** @return UASubscriptionProductTypeLegacy, UASubscriptionProductTypeAutorenewable or UASubscriptionProductTypeFree */
@property(nonatomic, assign) UASubscriptionProductType productType;

/** The duration of this autorenewable product. UAAutorenewableDurationNone returned if not an autorenewable */
@property(nonatomic, assign) UAAutorenewableDuration autorenewableDuration;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithSubscriptionProduct:(UASubscriptionProduct *)sp;
- (void)setPurchasingInfo:(NSDictionary *)purchasingInfo;

@end
