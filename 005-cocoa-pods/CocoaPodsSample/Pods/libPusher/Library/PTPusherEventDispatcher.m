//
//  PTPusherEventDispatcher.m
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PTPusherEventDispatcher.h"
#import "PTPusherEvent.h"


@implementation PTPusherEventDispatcher

- (id)init
{
  if ((self = [super init])) {
    eventListeners = [[NSMutableDictionary alloc] init];
  }
  return self;
}


#pragma mark - Managing event listeners

- (void)addEventListener:(id<PTEventListener>)listener forEventNamed:(NSString *)eventName
{
  NSMutableArray *listenersForEvent = [eventListeners objectForKey:eventName];
  
  if (listenersForEvent == nil) {
    listenersForEvent = [NSMutableArray array];
    [eventListeners setObject:listenersForEvent forKey:eventName];
  }
  [listenersForEvent addObject:listener];
}

#pragma mark - Dispatching events

- (void)dispatchEvent:(PTPusherEvent *)event
{
  for (id<PTEventListener> eventListener in [eventListeners objectForKey:event.name]) {
    [eventListener dispatchEvent:event];
  }
}

@end
