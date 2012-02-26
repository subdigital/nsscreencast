//
//  PTPusherChannelAuthorizationOperation.m
//  libPusher
//
//  Created by Luke Redpath on 14/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PTPusherChannelAuthorizationOperation.h"
#import "NSDictionary+QueryString.h"
#import "JSONKit.h"

@interface PTPusherChannelAuthorizationOperation ()
@property (nonatomic, strong, readwrite) NSDictionary *authorizationData;
@end

@implementation PTPusherChannelAuthorizationOperation

@synthesize authorized;
@synthesize authorizationData;
@synthesize completionHandler;

- (NSMutableURLRequest *)mutableURLRequest
{
  // we can be sure this is always mutable
  return (NSMutableURLRequest *)URLRequest;
}

+ (id)operationWithAuthorizationURL:(NSURL *)URL channelName:(NSString *)channelName socketID:(NSString *)socketID
{
  NSAssert(URL, @"URL is required for authorization! (Did you set PTPusher.authorizationURL?)");
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  
  NSMutableDictionary *requestData = [NSMutableDictionary dictionary];
  [requestData setObject:socketID forKey:@"socket_id"];
  [requestData setObject:channelName forKey:@"channel_name"];
  
  [request setHTTPBody:[[requestData sortedQueryString] dataUsingEncoding:NSUTF8StringEncoding]];
  
  return [[self alloc] initWithURLRequest:request];
}

- (void)finish
{
  [super finish];
  
  authorized = ([(NSHTTPURLResponse *)URLResponse statusCode] == 200);
  authorizationData = [responseData objectFromJSONData];

  if (self.completionHandler) {
    self.completionHandler(self);
  }
}

@end
