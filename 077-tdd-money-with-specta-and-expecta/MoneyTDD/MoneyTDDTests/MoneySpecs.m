#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Dollar.h"
#import "Euro.h"

SpecBegin(MoneySpecs)

/*
 $5 + €10 = $25 if rate is 2:1
 $5 + $5 = $10
 - hash
 
 */

describe(@"Dollar", ^{
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

SpecEnd