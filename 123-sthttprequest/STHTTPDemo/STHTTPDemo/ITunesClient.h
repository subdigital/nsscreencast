//
//  ITunesClient.h
//  STHTTPDemo
//
//  Created by Ben Scheirman on 5/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ITunesClientCompletionBlock)(NSArray *results, NSError *error);

@interface ITunesClient : NSObject

- (void)search:(NSString *)term completion:(ITunesClientCompletionBlock)block;

@end
