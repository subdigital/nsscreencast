//
//  Expression.h
//  MoneyTDD
//
//  Created by ben on 7/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Money, Bank;

@protocol Expression <NSObject>

- (Money *)reduceToCurrency:(NSString *)currency withBank:(Bank *)bank;
- (id<Expression>)plus:(id<Expression>)other;

@end
