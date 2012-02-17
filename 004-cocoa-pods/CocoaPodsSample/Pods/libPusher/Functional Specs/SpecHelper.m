//
//  SpecHelper.m
//  libPusher
//
//  Created by Luke Redpath on 13/12/2011.
//  Copyright (c) 2011 LJR Software Limited. All rights reserved.
//

#import "SpecHelper.h"
#import "Constants.h"
#import "PTPusherAPI.h"

PTPusher *newTestClient(void) {
  PTPusher *client = [PTPusher pusherWithKey:PUSHER_API_KEY connectAutomatically:NO encrypted:kUSE_ENCRYPTED_CONNECTION];
  client.delegate = [PTPusherClientTestHelperDelegate sharedInstance];

  [client connect];
  
  return [client retain];
}

void enableClientDebugging(void)
{
  [[PTPusherClientTestHelperDelegate sharedInstance] setDebugEnabled:YES];
}

void sendTestEvent(NSString *eventName)
{
  sendTestEventOnChannel(@"test-channel", eventName);
}

void sendTestEventOnChannel(NSString *channelName, NSString *eventName)
{
  __strong static PTPusherAPI *_sharedAPI = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedAPI = [[PTPusherAPI alloc] initWithKey:PUSHER_API_KEY appID:PUSHER_APP_ID secretKey:PUSHER_API_SECRET];
  });
  
  [_sharedAPI triggerEvent:eventName onChannel:channelName data:@"dummy data" socketID:@"99999"];
}

void onConnect(dispatch_block_t block)
{
  [[PTPusherClientTestHelperDelegate sharedInstance] onConnect:block];
}

@implementation PTPusherEventMatcher

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObjects:@"beEventNamed:", nil];
}

- (void)beEventNamed:(NSString *)name
{
  expectedEventName = [name copy];
}

- (BOOL)evaluate
{
  PTPusherEvent *event = self.subject;
  return [event.name isEqualToString:expectedEventName];
}

- (NSString *)failureMessageForShould
{
  return [NSString stringWithFormat:@"expected event named %@, got %@", expectedEventName, self.subject];
}

@end

@implementation PTPusherClientTestHelperDelegate

@synthesize debugEnabled;

+ (id)sharedInstance
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&pred, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

- (void)onConnect:(dispatch_block_t)block
{
  if (connected) {
    block();
  }
  else {
    [connectedBlock release];
    connectedBlock = [block retain];
  }
}

#pragma mark - Delegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
  if (self.debugEnabled) {
    NSLog(@"[DEBUG] Client connected");
  }
  if (connectedBlock) {
    connectedBlock();

    [connectedBlock release]; connectedBlock = nil;
  }
  connected = YES;
}

- (void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection
{
  if (self.debugEnabled) {
    NSLog(@"[DEBUG] Client disconnected");
  }
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
  if (self.debugEnabled) {
     NSLog(@"[DEBUG] Client connection failed with error %@", error);
  }
}

@end

@implementation PTPusherNotificationHandler

+ (id)sharedInstance
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&pred, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

- (id)init {
  if ((self = [super init])) {
    observers = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc 
{
  [observers release];
  [super dealloc];
}

- (void)addObserverForNotificationName:(NSString *)notificationName object:(id)object notificationCentre:(NSNotificationCenter *)notificationCenter withBlock:(void (^)(NSNotification *))block
{
  [observers setObject:block forKey:notificationName];
  [notificationCenter addObserver:self selector:@selector(handleNotification:) name:notificationName object:object];
}

- (void)handleNotification:(NSNotification *)note
{
  
  
  void (^block)(NSNotification *) = [observers objectForKey:note.name];
  
  if (block) {
    block(note);
  }
}

@end

@implementation NSNotificationCenter (BlockHandler)

- (void)addObserver:(NSString *)noteName object:(id)object usingBlock:(void (^)(NSNotification *))block
{
  [[PTPusherNotificationHandler sharedInstance] addObserverForNotificationName:noteName object:object notificationCentre:self withBlock:block];
}

@end
