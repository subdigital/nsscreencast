#import "Kiwi.h"
#import "GuessTheNumberGame.h"

SPEC_BEGIN(GuessTheNumberGameSpecs)

describe(@"Guess the number game", ^{
    __block GuessTheNumberGame *_game;
    
    beforeEach(^{
        _game = [[GuessTheNumberGame alloc] initWithAnswer:8];
    });
    
    it(@"can be created with an answer", ^{
        [[_game shouldNot] beNil];
        [[@(_game.answer) should] equal:@8];
    });
    
    it(@"should count the number of guesses", ^{
        [_game guess:1];
        [_game guess:2];
        [_game guess:3];
        [[@([_game numberOfGuesses]) should] equal:@3];
    });
    
    it(@"it should indicate when the guess is too low", ^{
        GuessResult result = [_game guess:2];
        GuessResult expected = GuessResultTooLow;
        [[@(result) should] equal:@(expected)];
    });
    
    it(@"it should indicate when the guess is too high", ^{
        GuessResult result = [_game guess:9];
        GuessResult expected = GuessResultTooHigh;
        [[@(result) should] equal:@(expected)];
    });

    it(@"it should indicate when the guess is correct", ^{
        GuessResult result = [_game guess:8];
        GuessResult expected = GuessResultCorrectAnswer;
        [[@(result) should] equal:@(expected)];
    });

});

SPEC_END