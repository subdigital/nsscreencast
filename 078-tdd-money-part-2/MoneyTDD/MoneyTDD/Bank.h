//
//  Bank.h
//  MoneyTDD
//
//  Created by ben on 7/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Money.h"

@interface Bank : NSObject

- (void)addRateForCurrency:(NSString *)from to:(NSString *)to rate:(CGFloat)rate;
- (CGFloat)rateForCurrency:(NSString *)from to:(NSString *)to;

- (Money *)reduce:(id<Expression>)expression toCurrency:(NSString *)currency;

@end
