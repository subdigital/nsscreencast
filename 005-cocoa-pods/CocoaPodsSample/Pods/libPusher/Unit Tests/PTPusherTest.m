//
//  PTPusherTest.m
//  libPusher
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "PTPusher.h"
#import "PTPusherEvent.h"

id<HCMatcher> eventWithName(NSString *name);
id<HCMatcher> eventWithData(NSString *data);
id<HCMatcher> eventWithNameAndData(NSString *name, NSString *data);
id<HCMatcher> eventWithDataValue(NSString *key, NSString *value);

@interface PTPusherTest : SenTestCase 
{
  PTPusher *pusher;
  id observerMock;
}
@end

id<HCMatcher> eventWithNameAndData(NSString *name, NSString *data)
{
  return allOf(eventWithName(name), eventWithData(data), nil);
}

id<HCMatcher> eventWithData(NSString *data)
{
  return passesBlock(^(id event) { return [[event valueForKey:@"data"] isEqualToString:data]; });
}

id<HCMatcher> eventWithName(NSString *name)
{
  return passesBlock(^(id event) { return [[event valueForKey:@"name"] isEqualToString:name]; });
}

id<HCMatcher> eventWithDataValue(NSString *key, NSString *value)
{
  NSString *keyPath = [@"data." stringByAppendingString:key];
  return passesBlock(^(id event) { return [[event valueForKeyPath:keyPath] isEqualToString:value]; });
}

#pragma mark -

@implementation PTPusherTest

static LRMockery *context = nil;

- (void)setUp;
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  pusher = [[PTPusher alloc] initWithKey:@"api_key" channel:@"my_channel"];
}

- (void)testShouldDispatchEventToListenerWhenAnEventIsReceived;
{
  id mockListener = [context mock];
  
  SEL callback = @selector(handleEvent:);
  
  [context checking:^(that){
    [oneOf(mockListener) performSelectorOnMainThread:callback withObject:anything() waitUntilDone:NO];
  }];
  
  [pusher addEventListener:@"test-event" target:mockListener selector:callback];
  
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":\"some data\"}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
  
  assertContextSatisfied(context);
}

- (void)testShouldDispatchToMultipleListenersWhenAnEventIsReceived;
{
  SEL callback = @selector(handleEvent:);
  
  id mockListenerOne = [context mockNamed:@"Listener 1"];
  id mockListenerTwo = [context mockNamed:@"Listener 2"];
  
  [context checking:^(that){
    [oneOf(mockListenerOne) performSelectorOnMainThread:callback withObject:anything() waitUntilDone:NO];
    [oneOf(mockListenerTwo) performSelectorOnMainThread:callback withObject:anything() waitUntilDone:NO];
  }];
  
  [pusher addEventListener:@"test-event" target:mockListenerOne selector:callback];
  [pusher addEventListener:@"test-event" target:mockListenerTwo selector:callback];
  
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":\"some data\"}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
  
  assertContextSatisfied(context);
}

- (void)testShouldPassAnEventToAnEventListenerWhenAnEventIsReceived;
{
  id mockListener = [context mock];

  SEL callback = @selector(handleEvent:);
  
  [context checking:^(that){
    [oneOf(mockListener) performSelectorOnMainThread:callback 
                                          withObject:eventWithNameAndData(@"test-event", @"some data")
                                       waitUntilDone:NO];
  }];
  
  [pusher addEventListener:@"test-event" target:mockListener selector:@selector(handleEvent:)];
  
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":\"some data\"}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
  
  assertContextSatisfied(context);
}

- (void)testShouldPostNotificationWhenEventIsReceived;
{
  [context expectNotificationNamed:PTPusherEventReceivedNotification];
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":\"some data\"}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
  
  assertContextSatisfied(context);
}

- (void)testShouldPassEventAsNotificationObjectWhenEventIsReceived;
{
  [context expectNotificationNamed:PTPusherEventReceivedNotification 
                        fromObject:eventWithNameAndData(@"test-event", @"some data")];

  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":\"some data\"}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
  
  assertContextSatisfied(context);
}

- (void)testShouldParseEncodedJsonDataReceivedInDataKey;
{
  id mockListener = [context mock];
  
  SEL callback = @selector(handleEvent:);
  
  [context checking:^(that){
    [oneOf(mockListener) performSelectorOnMainThread:callback 
                                          withObject:eventWithDataValue(@"foo", @"bar")
                                       waitUntilDone:NO];
  }];
  
  [pusher addEventListener:@"test-event" target:mockListener selector:@selector(handleEvent:)];
  
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":{\\\"foo\\\":\\\"bar\\\"}}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
}

- (void)testShouldParseUnencodedJsonDataReceivedInDataKey;
{
  id mockListener = [context mock];
  
  SEL callback = @selector(handleEvent:);
  
  [context checking:^(that){
    [oneOf(mockListener) performSelectorOnMainThread:callback 
                                          withObject:eventWithDataValue(@"foo", @"bar")
                                       waitUntilDone:NO];
  }];
  
  [pusher addEventListener:@"test-event" target:mockListener selector:@selector(handleEvent:)];
  
  NSString *rawJSON = @"{\"event\":\"test-event\",\"data\":{\"foo\":\"bar\"}}";
  [pusher performSelector:@selector(webSocket:didReceiveMessage:) withObject:nil withObject:rawJSON];
}

@end
