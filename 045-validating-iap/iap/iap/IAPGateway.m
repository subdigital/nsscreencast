//
//  IAPGateway.m
//  iap
//
//  Created by Ben Scheirman on 12/4/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "IAPGateway.h"

NSString * const IAPGatewayProductPurchased = @"IAPGatewayProductPurchased";

@interface IAPGateway () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, copy) NSSet *productIds;
@property (nonatomic, copy) IAPGatewayProductsBlock callback;
@end

static NSString * CBBase64EncodedStringFromData(NSData *data) {
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

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

- (void)verifyReceipt:(NSData *)receipt completion:(void (^)(BOOL valid))completion {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/receipts/validate"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"receipt_data=%@", CBBase64EncodedStringFromData(receipt)];
    NSData *paramData = [param dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               NSLog(@"HTTP %d", httpResponse.statusCode);
                               NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               
                               if (httpResponse.statusCode == 200) {
                                   completion(YES);
                               } else {
                                   completion(NO);
                               }
                           }];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionReceipt) {
            NSLog(@"Receipt data: %@", CBBase64EncodedStringFromData(transaction.transactionReceipt));
        }
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                [self verifyReceipt:transaction.transactionReceipt completion:^(BOOL valid) {
                    [self markProductPurchased:transaction.payment.productIdentifier];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed: %@", transaction.error.localizedDescription);
                // raise notification?
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored: {
                [self verifyReceipt:transaction.transactionReceipt completion:^(BOOL valid){
                    [self markProductPurchased:transaction.payment.productIdentifier];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }];

                break;
            }
        }
    }
}

@end
