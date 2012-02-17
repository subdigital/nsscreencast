//
//  PusherEventsViewController.h
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PTPusher;
@class PTPusherChannel;
@class PTPusherAPI;

@protocol PusherEventsDelegate
- (void)sendEventWithMessage:(NSString *)message;
@end

@interface PusherEventsViewController : UITableViewController <PusherEventsDelegate> {
  NSMutableArray *eventsReceived;
}
@property (nonatomic, retain) PTPusher *pusher;
@property (nonatomic, retain) PTPusherAPI *pusherAPI;
@property (nonatomic, retain) PTPusherChannel *currentChannel;
@property (nonatomic, readonly) NSMutableArray *eventsReceived;

- (void)subscribeToChannel:(NSString *)channelName;
@end
