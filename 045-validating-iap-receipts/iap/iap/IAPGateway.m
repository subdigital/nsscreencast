//
//  IAPGateway.m
//  iap
//
//  Created by Ben Scheirman on 12/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "IAPGateway.h"
#import "NSData+Base64.h"

typedef void (^IAPGatewayReceiptValidateBlock)(BOOL ok, id receipt);

NSString * const IAPGatewayProductPurchased = @"IAPGatewayProductPurchased";

@interface IAPGateway () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, copy) NSSet *productIds;
@property (nonatomic, copy) IAPGatewayProductsBlock callback;
@end

@implementation IAPGateway

- (id)initWithProductIds:(NSSet *)productIds {
    self = [super init];
    if (self) {
        self.productIds = productIds;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)fetchProductsWithBlock:(IAPGatewayProductsBlock)block {
    self.callback = block;
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIds];
    request.delegate = self;
    [request start];
}

- (BOOL)isProductPurchased:(SKProduct *)product {
    return [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
}

- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (SKProduct *product in response.products) {
        NSLog(@"Found product: %@ %@ %@",
              product.localizedTitle,
              product.localizedDescription,
              product.price);
    }
    
    self.callback(YES, response.products);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
    self.callback(NO, nil);
}

#pragma mark - payment transaction observer

- (void)markProductPurchased:(NSString *)productIdentifier {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPGatewayProductPurchased
                                                        object:productIdentifier];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                [self validateReceipt:transaction.transactionReceipt
                           completion:^(BOOL ok, id receipt) {
                               [self markProductPurchased:transaction.payment.productIdentifier];
                               [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                           }];
            }
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed: %@", transaction.error.localizedDescription);
                // raise notification?
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored: {
                [self validateReceipt:transaction.transactionReceipt
                           completion:^(BOOL ok, id receipt) {
                               [self markProductPurchased:transaction.originalTransaction.payment.productIdentifier];
                               [[SKPaymentQueue defaultQueue] finishTransaction:transaction];                               
                           }];
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)validateReceipt:(NSData *)receiptData completion:(IAPGatewayReceiptValidateBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/receipts/validate"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"receipt_data=%@", [receiptData base64EncodedString]];
    NSData *httpBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:httpBody];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (httpResponse.statusCode == 200) {
                                   id receipt = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0 error:nil];
                                   NSLog(@"Received receipt: %@", receipt);
                                   completion(YES, receipt);
                               } else {
                                   NSLog(@"Body: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                   NSLog(@"ERROR: %@", error);
                                   NSLog(@"HTTP STATUS: %d", httpResponse.statusCode);
                                   completion(NO, nil);
                               }
                           }];
}

@end
