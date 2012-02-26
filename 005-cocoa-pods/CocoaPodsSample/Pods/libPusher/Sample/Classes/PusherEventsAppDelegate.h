//
//  PusherEventsAppDelegate.h
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPusherDelegate.h"

@class PusherExampleMenuViewController;
@class PTPusher;

@interface PusherEventsAppDelegate : NSObject <UIApplicationDelegate, PTPusherDelegate> {
  NSMutableArray *connectedClients;
  NSMutableArray *clientsAwaitingConnection;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet PusherExampleMenuViewController *menuViewController;
@property (nonatomic, retain) PTPusher *pusher;

- (PTPusher *)lastConnectedClient;
- (PTPusher *)createClientWithAutomaticConnection:(BOOL)connectAutomatically;
@end

