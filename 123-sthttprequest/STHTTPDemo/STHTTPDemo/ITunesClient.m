//
//  ITunesClient.m
//  STHTTPDemo
//
//  Created by Ben Scheirman on 5/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ITunesClient.h"
#import "STHTTPRequest.h"

@implementation ITunesClient

- (void)search:(NSString *)term completion:(ITunesClientCompletionBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?country=us&term=%@",
                           [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:urlString];
    request.completionBlock = ^(NSDictionary *headers, NSString *body) {
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        block(jsonResponse[@"results"], nil);
    };
    
    request.errorBlock = ^(NSError *error) {
        NSLog(@"ERROR: %@", error);
        block(nil, error);
    };
    
    [request startAsynchronous];
}

@end
