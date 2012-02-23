//
//  GuessTheNumberGame.m
//  GuessTheNumber
//
//  Created by Ben Scheirman on 2/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "GuessTheNumberGame.h"

@implementation GuessTheNumberGame

@synthesize answer = _answer;
@synthesize numberOfGuesses = _numberOfGuesses;

- (id)initWithAnswer:(NSInteger)answer {
    self = [super init];
    if (self) {
        _answer = answer;
    }
    return self;
}

- (GuessResult)guess:(NSInteger)number {
    _numberOfGuesses++;
    
    if (number < self.answer) {
        return GuessResultTooLow;
    } else if (number > self.answer) {
        return GuessResultTooHigh;
    }
    
    return GuessResultCorrectAnswer;
}

@end
