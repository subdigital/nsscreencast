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

@class UASubscriptionProduct;
@class UASubscriptionContent;

@interface UASubscription : NSObject {
  @private
    NSString *key;
    NSString *name;
    BOOL subscribed;
    NSMutableArray *products;
    // copies of products that have been purchased
    NSMutableArray *purchasedProducts;
    NSMutableArray *availableProducts;
    NSMutableArray *availableContents;
    NSMutableArray *downloadedContents;
    NSMutableArray *undownloadedContents;
}

///---------------------------------------------------------------------------------------
/// @name Subscription Properties
///---------------------------------------------------------------------------------------

/** The subscription key */
@property (nonatomic, retain, readonly) NSString *key;

/** The subscription name */
@property (nonatomic, retain, readonly) NSString *name;

//TODO: is this currently subscribed?
/** YES if the user subscribed, otherwise NO */
@property (nonatomic, assign, readonly) BOOL subscribed;


///---------------------------------------------------------------------------------------
/// @name Products and Content
///---------------------------------------------------------------------------------------

/**
 * Array of all products available for this subscription, including
 * promotional/default/extension subscriptions not for sale.
 */
@property (nonatomic, retain, readonly) NSMutableArray *products;

/**
 * Array of all products purchased by this user.
 *
 * Note that these products are _copies_ of the products available
 * through the products property. Only these copies have the 
 * [UASubscriptionProduct purchased] flag set and  valid 
 * [UASubscriptionProduct startDate] and [UASubscriptionProduct endDate]
 * values.
 */
@property (nonatomic, retain, readonly) NSMutableArray *purchasedProducts;

/**
 * Array of all products available for purchase on this subscription.
 * This array only includes products currently for sale in the App Store
 * and will not include "free"/default/extension products.
 */
@property (nonatomic, retain, readonly) NSMutableArray *availableProducts;

/**
 * Array of all the content available to this user via their purchased products.
 */
@property (nonatomic, retain, readonly) NSMutableArray *availableContents;

/** Array of all of the content that the user has downloaded. */
@property (nonatomic, retain, readonly) NSMutableArray *downloadedContents;

/** Array of all the content that the user has not yet downloaded */
@property (nonatomic, retain, readonly) NSMutableArray *undownloadedContents;

// Private methods
- (id)initWithKey:(NSString *)aKey name:(NSString *)aName;
- (void)setProductsWithArray:(NSArray *)productArray;
- (void)setPurchasedProductsWithArray:(NSArray *)infos;
- (void)setContentWithArray:(NSArray *)content;
- (void)filterDownloadedContents;

@end
