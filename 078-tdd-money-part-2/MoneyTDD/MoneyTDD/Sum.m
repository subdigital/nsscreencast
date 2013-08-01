//
//  Sum.m
//  MoneyTDD
//
//  Created by ben on 7/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "Sum.h"

@implementation Sum

- (Money *)reduceToCurrency:(NSString *)currency withBank:(Bank *)bank {
    int amount = [self.augend reduceToCurrency:currency withBank:bank].amount +
                [self.addend reduceToCurrency:currency withBank:bank].amount;
    return [[Money alloc] initWithAmount:amount currency:currency];
}

- (id<Expression>)plus:(id<Expression>)other {
    Sum *sum = [[Sum alloc] init];
    sum.augend = self;
    sum.addend = other;
    return sum;
}

@end
