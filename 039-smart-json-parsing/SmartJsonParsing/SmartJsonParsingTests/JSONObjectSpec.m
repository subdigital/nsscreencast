#import "Kiwi.h"
#import "TestPerson.h"

SPEC_BEGIN(JSONObjectSpec)


describe(@"Normalizing keys", ^{
   it(@"should normalize snake_case", ^{
       [[[JSONObject normalizedKey:@"first_name"] should] equal:@"firstName"];
   });
   it(@"should normalize PascalCase", ^{
       [[[JSONObject normalizedKey:@"LastName"] should] equal:@"lastName"];
   });
});

describe(@"Parsing from json", ^{
    __block id _json;
    __block TestPerson *_person;
    
    beforeEach(^{
        _json = @{ @"first_name": @"Bob", @"LastName": @"Smith" };
        _person = [TestPerson objectWithDictionary:_json];
    });
    
    it(@"should create a test person", ^{
        [[_person shouldNot] beNil];
    });
    
    it(@"can parse the first name", ^{
        [[_person.firstName should] equal:@"Bob"];
    });
    
    it(@"can parse the last name", ^{
        [[_person.lastName should] equal:@"Smith"];
    });
});

SPEC_END