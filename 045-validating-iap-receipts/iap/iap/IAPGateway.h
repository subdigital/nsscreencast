//
//  IAPGateway.h
//  iap
//
//  Created by Ben Scheirman on 12/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NSString * const IAPGatewayProductPurchased;

typedef void (^IAPGatewayProductsBlock)(BOOL success, NSArray *products);

@interface IAPGateway : NSObject

- (id)initWithProductIds:(NSSet *)productIds;
- (void)fetchProductsWithBlock:(IAPGatewayProductsBlock)block;
- (BOOL)isProductPurchased:(SKProduct *)product;
- (void)purchaseProduct:(SKProduct *)product;
@end
