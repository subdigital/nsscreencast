//
//  ASIInputStream.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 10/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UA_ASIHTTPRequest;

// This is a wrapper for NSInputStream that pretends to be an NSInputStream itself
// Subclassing NSInputStream seems to be tricky, and may involve overriding undocumented methods, so we'll cheat instead.
// It is used by UA_ASIHTTPRequest whenever we have a request body, and handles measuring and throttling the bandwidth used for uploading

@interface UA_ASIInputStream : NSObject {
	NSInputStream *stream;
	UA_ASIHTTPRequest *request;
}
+ (id)inputStreamWithFileAtPath:(NSString *)path request:(UA_ASIHTTPRequest *)request;
+ (id)inputStreamWithData:(NSData *)data request:(UA_ASIHTTPRequest *)request;

@property (retain, nonatomic) NSInputStream *stream;
@property (assign, nonatomic) UA_ASIHTTPRequest *request;
@end
