#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Money.h"
#import "Expression.h"
#import "Bank.h"

SpecBegin(MoneySpecs)

/*
 ($5 + $1) * 2 = $12
 ($3 + €6) *3 = .... if rate
 */

describe(@"Money", ^{
    it(@"can be multplied", ^{
        Money *five = [Money dollarWithAmount:5];
        expect([five times:2]).to.equal([Money dollarWithAmount:10]);
        expect([five times:3]).to.equal([Money dollarWithAmount:15]);
    });
    
    it(@"can test equality", ^{
        expect([Money dollarWithAmount:5]).to.equal([Money dollarWithAmount:5]);
        expect([Money euroWithAmount:5]).notTo.equal([Money euroWithAmount:6]);
        expect([Money dollarWithAmount:1]).notTo.equal([Money euroWithAmount:1]);
    });
    
    it(@"has a good description", ^{
        expect([[Money dollarWithAmount:4] description]).to.equal(@"4 USD");
        expect([[Money euroWithAmount:5] description]).to.equal(@"5 EUR");
    });
});

describe(@"Bank", ^{
    __block Bank *_bank;
    beforeEach(^{
        _bank = [[Bank alloc] init];
    });
    
    it(@"can reduce money", ^{
        Money *fiveDollar = [Money dollarWithAmount:5];
        Money *result = [_bank reduce:fiveDollar toCurrency:@"USD"];
        expect(result).to.equal(fiveDollar);
    });
    
    it(@"can reduce sums of the same currency", ^{
        Money *fiveDollars = [Money dollarWithAmount:5];
        id<Expression> sum = [fiveDollars plus:fiveDollars];
        Bank *bank = [[Bank alloc] init];
        Money *result = [bank reduce:sum toCurrency:@"USD"];
        expect(result).to.equal([Money dollarWithAmount:10]);
    });

    context(@"an exchange rate for USD->EUR", ^{
        beforeEach(^{
            [_bank addRateForCurrency:@"USD" to:@"EUR" rate:2];
        });
        
        it(@"can reduce sums of different currencies", ^{
            Money *tenDollars = [Money dollarWithAmount:10];
            Money *fiveEuros = [Money euroWithAmount:5];
            id<Expression> sum = [tenDollars plus:fiveEuros];
            Money *result = [_bank reduce:sum toCurrency:@"USD"];
            expect(result).to.equal([Money dollarWithAmount:20]);
        });
        
        it(@"returns 1 for the same currency", ^{
            expect([_bank rateForCurrency:@"USD" to:@"USD"]).to.equal(1);
        });
        
        it(@"return the exchange for known currencies", ^{
            expect([_bank rateForCurrency:@"USD" to:@"EUR"]).to.equal(2);
        });
        
        it(@"should automatically add the inverse exchange", ^{
            expect([_bank rateForCurrency:@"EUR" to:@"USD"]).to.equal(0.5);
        });
        
        it(@"returns nil for unkonwn currencies", ^{
            expect([_bank rateForCurrency:@"USD" to:@"GBP"]).to.equal(0);
        });
        
        it(@"can reduce money with conversion", ^{
            Money *tenDollars = [Money dollarWithAmount:10];
            Money *result = [_bank reduce:tenDollars toCurrency:@"EUR"];
            expect(result).to.equal([Money euroWithAmount:5]);
        });
        
        it(@"can reduce complex expressions", ^{
            Money *tenDollars = [Money dollarWithAmount:10];
            Money *fiveEuros = [Money euroWithAmount:5];
            id<Expression> sum = [tenDollars plus:fiveEuros];
            id<Expression> outerSum = [sum plus:tenDollars];
            Money *result = [_bank reduce:outerSum toCurrency:@"USD"];
            expect(result).to.equal([Money dollarWithAmount:30]);
     
        });
    });
    
});

SpecEnd