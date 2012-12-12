//
//  IAPGateway.m
//  iap
//
//  Created by ben on 12/2/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "IAPGateway.h"

NSString * const IAPGatewayProductPurchasedNotification = @"IAPGatewayProductPurchased";

@interface IAPGateway () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, copy) NSSet *productIdentifiers;
@property (nonatomic, copy) IAPProductsBlock productsBlock;

@end

@implementation IAPGateway

- (id)initWithProductIdentifiers:(NSSet *)productIdSet {
    self = [super init];
    if (self) {
        self.productIdentifiers = productIdSet;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (BOOL)isProductPurchased:(NSString *)sku {
    return [[NSUserDefaults standardUserDefaults] boolForKey:sku];
}

- (void)fetchProductsWithCompletion:(IAPProductsBlock)block {
    self.productsBlock = block;
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    request.delegate = self;
    [request start];
}

- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in response.products) {
        NSLog(@"Product: %@ %@ %0.2f",
              product.productIdentifier,
              product.localizedTitle,
              product.price.floatValue);
    }
    
    self.productsBlock(YES, response.products);
    self.productsBlock = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.productsBlock(NO, nil);
    self.productsBlock = nil;
}

#pragma mark - SKTransactionObserver methods

- (void)markProductPurchased:(NSString *)productIdentifier {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // notify the rest of the app
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPGatewayProductPurchasedNotification
                                                        object:productIdentifier];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self markProductPurchased:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed!");
                
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    NSLog(@"The user cancelled...");
                } else {
                    NSLog(@"The error was: %@", transaction.error.localizedDescription);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                [self markProductPurchased:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    };
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    
}

@end
