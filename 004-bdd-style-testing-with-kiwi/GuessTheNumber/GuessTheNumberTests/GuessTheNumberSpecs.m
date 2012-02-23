#import "Kiwi.h"
#import "GuessTheNumberGame.h"

SPEC_BEGIN(GuessTheNumberGameSpecs)

describe(@"Guess the number game", ^{
    __block GuessTheNumberGame *_game;
    
    beforeEach(^{
        _game = [[[GuessTheNumberGame alloc] initWithAnswer:8] autorelease]; 
    });
    
    it(@"can be created with an answer", ^{
        [[_game shouldNot] beNil];
        [[theValue(_game.answer) should] equal:theValue(8)];
    });
    
    it(@"should count the number of guesses", ^{
        [_game guess:1];
        [_game guess:2];
        [_game guess:3];
        [[theValue([_game numberOfGuesses]) should] equal:theValue(3)];
    });
    
    it(@"it should indicate when the guess is too low", ^{
        GuessResult result = [_game guess:2];
        GuessResult expected = GuessResultTooLow;
        [[theValue(result) should] equal:theValue(expected)];
    });
    
    it(@"it should indicate when the guess is too high", ^{
        GuessResult result = [_game guess:9];
        GuessResult expected = GuessResultTooHigh;
        [[theValue(result) should] equal:theValue(expected)];
    });

    it(@"it should indicate when the guess is correct", ^{
        GuessResult result = [_game guess:8];
        GuessResult expected = GuessResultCorrectAnswer;
        [[theValue(result) should] equal:theValue(expected)];        
    });

});

SPEC_END