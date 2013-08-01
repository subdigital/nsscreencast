//
//  Bank.m
//  MoneyTDD
//
//  Created by ben on 7/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "Bank.h"
#import "Sum.h"

#define BANK_RATE_KEY(from, to) [NSString stringWithFormat:@"%@:%@", from, to]

@interface Bank ()
@property (nonatomic, strong) NSMutableDictionary *exchangeRates;
@end

@implementation Bank

- (id)init {
    self = [super init];
    if (self) {
        self.exchangeRates = [NSMutableDictionary dictionary];
    }
    return self;
}

- (Money *)reduce:(id<Expression>)expression toCurrency:(NSString *)currency {
    return [expression reduceToCurrency:currency withBank:self];
}

- (void)addRateForCurrency:(NSString *)from to:(NSString *)to rate:(CGFloat)rate {
    NSString *key = BANK_RATE_KEY(from, to);
    self.exchangeRates[key] = @(rate);
    
    NSString *inverseKey = BANK_RATE_KEY(to, from);
    self.exchangeRates[inverseKey] = @(1/rate);
}

- (CGFloat)rateForCurrency:(NSString *)from to:(NSString *)to {
    if ([from isEqualToString:to]) {
        return 1;
    }
    NSNumber *rate = self.exchangeRates[BANK_RATE_KEY(from, to)];
    return [rate floatValue];
}


@end
