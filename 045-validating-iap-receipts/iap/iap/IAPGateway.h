//
//  IAPGateway.h
//  iap
//
//  Created by ben on 12/2/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NSString * const IAPGatewayProductPurchasedNotification;

typedef void (^IAPProductsBlock)(BOOL worked, NSArray *products);

@interface IAPGateway : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdSet;
- (BOOL)isProductPurchased:(NSString *)sku;
- (void)fetchProductsWithCompletion:(IAPProductsBlock)block;
- (void)purchaseProduct:(SKProduct *)product;

@end
