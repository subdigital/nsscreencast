//
//  PTPusherConnection.m
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PTPusherConnection.h"
#import "PTPusherEvent.h"
#import "JSONKit.h"

NSString *const PTPusherConnectionEstablishedEvent = @"pusher:connection_established";
NSString *const PTPusherConnectionPingEvent        = @"pusher:ping";

@interface PTPusherConnection ()
@property (nonatomic, copy) NSString *socketID;
@property (nonatomic, assign, readwrite) BOOL connected;

- (void)respondToPingEvent;
@end

@implementation PTPusherConnection

@synthesize delegate = _delegate;
@synthesize connected;
@synthesize socketID;

- (id)initWithURL:(NSURL *)aURL secure:(BOOL)secure
{
  if ((self = [super init])) {
    socket = [[ZTWebSocket alloc] initWithURLString:[aURL absoluteString] delegate:self secure:secure];
  }
  return self;
}

- (void)dealloc 
{
  [socket close];
}

#pragma mark - Connection management

- (void)connect;
{
  if (self.isConnected)
    return;

  [socket open];
}

- (void)disconnect;
{
  if (!self.isConnected)
    return;
  
  [socket close];
}

#pragma mark - Sending data

- (void)send:(id)object
{
  NSData *JSONData = [object JSONData];
  NSString *message = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
  [socket send:message];
}

#pragma mark - ZTWebSocket delegate methods

- (void)webSocket:(ZTWebSocket*)webSocket didFailWithError:(NSError*)error;
{
  [self.delegate pusherConnection:self didFailWithError:error];
}

- (void)webSocketDidClose:(ZTWebSocket*)webSocket;
{
  self.connected = NO;
  [self.delegate pusherConnectionDidDisconnect:self];
  self.socketID = nil;
}

- (void)webSocket:(ZTWebSocket*)webSocket didReceiveMessage:(NSString*)message;
{
  NSDictionary *messageDictionary = [message objectFromJSONString];
  PTPusherEvent *event = [PTPusherEvent eventFromMessageDictionary:messageDictionary];
  
  if ([event.name isEqualToString:PTPusherConnectionPingEvent]) {
    // don't forward on ping events, just handle them and return
    [self respondToPingEvent];
    return;
  }
  
  if ([event.name isEqualToString:PTPusherConnectionEstablishedEvent]) {
    self.socketID = [event.data objectForKey:@"socket_id"];
    self.connected = YES;

    [self.delegate pusherConnectionDidConnect:self];
  }
  
  [self.delegate pusherConnection:self didReceiveEvent:event];
}

#pragma mark -

- (void)respondToPingEvent
{
#ifdef DEBUG
  NSLog(@"[pusher] Responding to ping (pong!)");
#endif
  
  [self send:[NSDictionary dictionaryWithObject:@"pusher:pong" forKey:@"event"]];
}

@end
