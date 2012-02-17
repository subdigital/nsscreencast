//
//  SpecHelper.h
//  libPusher
//
//  Created by Luke Redpath on 13/12/2011.
//  Copyright (c) 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kiwi.h"
#import "PTPusher.h"
#import "PTPusherEvent.h"

#define kUSE_ENCRYPTED_CONNECTION YES

// helper methods

PTPusher *newTestClient(void);
void enableClientDebugging(void);
void sendTestEvent(NSString *eventName);
void sendTestEventOnChannel(NSString *channelName, NSString *eventName);
void onConnect(dispatch_block_t);

// helper classes

@interface PTPusherEventMatcher : KWMatcher {
  NSString *expectedEventName;
}
- (void)beEventNamed:(NSString *)name;
@end

@interface PTPusherClientTestHelperDelegate : NSObject <PTPusherDelegate> {
  BOOL connected;
  dispatch_block_t connectedBlock;
}
@property (nonatomic, assign) BOOL debugEnabled;

+ (id)sharedInstance;
- (void)onConnect:(dispatch_block_t)block;
@end

@interface PTPusherNotificationHandler : NSObject {
  NSMutableDictionary *observers;
}
@end

@interface NSNotificationCenter (BlockHandler)
- (void)addObserver:(NSString *)noteName object:(id)object usingBlock:(void (^)(NSNotification *))block;
@end