//
//  Sum.h
//  MoneyTDD
//
//  Created by ben on 7/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Bank.h"

@interface Sum : NSObject <Expression>

@property (nonatomic, strong) id<Expression> augend;
@property (nonatomic, strong) id<Expression> addend;

@end
