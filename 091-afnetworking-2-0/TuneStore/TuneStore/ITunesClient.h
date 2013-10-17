//
//  ITunesClient.h
//  TuneStore
//
//  Created by ben on 10/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ITunesClient : AFHTTPSessionManager

+ (ITunesClient *)sharedClient;

- (NSURLSessionDataTask *)searchForTerm:(NSString *)term completion:( void (^)(NSArray *results, NSError *error) )completion;

@end
