//
//  GuessTheNumberGame.h
//  GuessTheNumber
//
//  Created by Ben Scheirman on 2/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GuessResultTooLow = 1,
    GuessResultTooHigh,
    GuessResultCorrectAnswer
} GuessResult;

@interface GuessTheNumberGame : NSObject

@property (nonatomic, readonly) NSInteger answer;
@property (nonatomic, readonly) NSInteger numberOfGuesses;

- (id)initWithAnswer:(NSInteger)answer;

- (GuessResult)guess:(NSInteger)number;

@end
