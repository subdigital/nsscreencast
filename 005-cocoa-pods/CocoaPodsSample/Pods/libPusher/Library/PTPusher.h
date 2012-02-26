//
//  PTPusher.h
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPusherDelegate.h"
#import "PTPusherConnection.h"
#import "PTPusherEventPublisher.h"
#import "PTPusherPresenceChannelDelegate.h"

/** The Pusher protocol version, used to determined which features
 are supported.
 */
#define kPTPusherClientProtocolVersion 5

/** The version number of the libPusher library.
 */
#define kPTPusherClientLibraryVersion  1.0

/** The name of the notification posted when PTPusher receives an event.
 */
extern NSString *const PTPusherEventReceivedNotification;

/** The key of the PTPusherEvent object in the PTPusherEventReceivedNotification userInfo dictionary.
 */
extern NSString *const PTPusherEventUserInfoKey;

/** The error domain for all PTPusher errors.
 */
extern NSString *const PTPusherErrorDomain;

/** The key for any underlying PTPusherEvent associated with a PTPusher error's userInfo dictionary.
 */
extern NSString *const PTPusherErrorUnderlyingEventKey;

@class PTPusherChannel;
@class PTPusherPresenceChannel;
@class PTPusherPrivateChannel;
@class PTPusherEventDispatcher;

/** A PTPusher object provides a high level API for communicating with the Pusher service.
 
 The provided API allows you to connect and disconnect from the service, subscribe and unsubscribe
 from channels and bind to events. There is also beta support for sending events directly over the 
 connection (instead of using the Pusher REST API).
 
 To create an instance of PTPusher, you will need your Pusher API key. This can be obtained from your account
 dashboard. 
 
 PTPusher's delegate methods allow an object to receive important events in the client and connection's
 lifecycle, such as connection, disconnection, reconnection and channel subscribe/unsubscribe events.
 
 Whilst PTPusher exposes it's connection object as a readonly property, there is no need to manage or
 create this connection manually. The connection can be queried for it's current connection state and
 socket ID if needed.
 
 PTPusher aims to mirror the Pusher Javascript client API as much as possible although whilst the 
 Javascript API uses event binding for any interesting events - not just server or other client events -
 libPusher uses standard Cocoa and Objective-C patterns such as delegation and notification where
 it makes sense to do so.
 
 Note: due to various problems people have had connecting to Pusher without SSL over a 3G connection,
 it is highly recommend that you use SSL. For this reason, SSL is enabled by default.
 */
@interface PTPusher : NSObject <PTPusherConnectionDelegate, PTPusherEventBindings> {
  PTPusherEventDispatcher *dispatcher;
  NSMutableDictionary *channels;
}

///------------------------------------------------------------------------------------/
/// @name Properties
///------------------------------------------------------------------------------------/

/** The object that acts as the delegate for the receiving instance.
 
 The delegate must implement the PTPusherDelegate protocol. The delegate is not retained.
 */
@property (nonatomic, unsafe_unretained) id<PTPusherDelegate> delegate;


/** Indicates whether the client should attempt to reconnect automatically when disconnected
 or if the connection failed.
 
 When YES, the client will automatically attempt to re-establish a connection after a set delay.
 
 If the reconnection attempt fails, the client will continue to attempt to reconnect until this
 property is set to NO. The delegate will be notified of each reconnection attempt; you could use
 this method to disable reconnection after a number of attempts.
 */
@property (nonatomic, assign, getter=shouldReconnectAutomatically) BOOL reconnectAutomatically;

/** Specifies the delay between reconnection attempts. Defaults to 5 seconds.
 */
@property (nonatomic, assign) NSTimeInterval reconnectDelay;

/** The connection object for this client.
 
 Each instance uses a single connection only. Most clients will likely only ever need a single
 PTPusher object and therefore a single connection.
 
 The connection is exposed to provide access to it's socketID and connection state. Clients
 should not attempt to manage this connection directly.
 */
@property (nonatomic, strong, readonly) PTPusherConnection *connection;

/** The authorization URL for private subscriptions.
 
 All private channels (including presence channels) require authorization in order to subscribe.
 
 Authorization happens on your own server. When subscribing to a private or presence channel, 
 an authorization POST request will be sent to the URL specified by this property.
 
 Attempting to subscribe to a private or presence channel without setting this property will
 result in an assertion error.
 
 For more information on channel authorization, [see the Pusher documentation website](http://pusher.com/docs/authenticating_users).
 */
@property (nonatomic, strong) NSURL *authorizationURL;

///------------------------------------------------------------------------------------/
/// @name Creating new instances
///------------------------------------------------------------------------------------/

- (id)initWithConnection:(PTPusherConnection *)connection connectAutomatically:(BOOL)connectAutomatically;

/** Returns a new PTPusher instance with a connection configured with the given key.
 
 Instances created using this method will connect automatically. Specify the delegate here
 to ensure that it is notified about the connection status during connection. If you assign 
 a delegate using the delegate property after this method returns, it may not be notified
 of connection events.
 
 @deprecated
 @param key       Your application's API key. It can be found in the API Access section of your application within the Pusher user dashboard.
 @param delegate  The delegate for this instance
 */
+ (id)pusherWithKey:(NSString *)key delegate:(id<PTPusherDelegate>)delegate;

/** Returns a new PTPusher instance with a connection configured with the given key.
 
 Instances created using this method will connect automatically. Specify the delegate here
 to ensure that it is notified about the connection status during connection. If you assign 
 a delegate using the delegate property after this method returns, it may not be notified
 of connection events.
 
 @param key         Your application's API key. It can be found in the API Access section of your application within the Pusher user dashboard.
 @param delegate    The delegate for this instance
 @param isEncrypted If yes, a secure connection over SSL will be established.
 */
+ (id)pusherWithKey:(NSString *)key delegate:(id<PTPusherDelegate>)delegate encrypted:(BOOL)isEncrypted;

/** Initialises a new PTPusher instance with a connection configured with the given key.
 
 If you intend to set a delegate for this instance, you are recommended to set connectAutomatically
 to NO, set the delegate then manually call connect.
 
 @deprecated
 @param key       Your application's API key. It can be found in the API Access section of your application within the Pusher user dashboard.
 @param connect   Automatically If YES, the connection will be connected on initialisation.
 */
+ (id)pusherWithKey:(NSString *)key connectAutomatically:(BOOL)connectAutomatically;

/** Initialises a new PTPusher instance with a connection configured with the given key.
 
 If you intend to set a delegate for this instance, you are recommended to set connectAutomatically
 to NO, set the delegate then manually call connect.
 
 @param key       Your application's API key. It can be found in the API Access section of your application within the Pusher user dashboard.
 @param connectAutomatically If YES, the connection will be connected on initialisation.
 @param isEncrypted If yes, a secure connection over SSL will be established.
 */
+ (id)pusherWithKey:(NSString *)key connectAutomatically:(BOOL)connectAutomatically encrypted:(BOOL)isEncrypted;

///------------------------------------------------------------------------------------/
/// @name Managing the connection
///------------------------------------------------------------------------------------/

/** Establishes a connection to the Pusher server.
 
 If already connected, this method does nothing.
 */
- (void)connect;

/** Disconnects from the Pusher server.
 
 If already disconnected, this method does nothing.
 */
- (void)disconnect;

///------------------------------------------------------------------------------------/
/// @name Subscribing to channels
///------------------------------------------------------------------------------------/

/** Subscribes to the named channel.
 
 This method can be used to subscribe to any type of channel, including private and
 presence channels by including the appropriate channel name prefix.
 
 @param name The name of the channel to subscribe to.
 */
- (PTPusherChannel *)subscribeToChannelNamed:(NSString *)name;

/** Subscribes to the named private channel.
 
 The "private-" prefix should be excluded from the name; it will be added automatically.
 
 @param name The name of the channel (without the private prefix) to subscribe to.
 */
- (PTPusherPrivateChannel *)subscribeToPrivateChannelNamed:(NSString *)name;

/** Subscribes to the named presence channel.
 
 The "presence-" prefix should be excluded from the name; it will be added automatically.
 
 @param name The name of the channel (without the presence prefix) to subscribe to.
 */
- (PTPusherPresenceChannel *)subscribeToPresenceChannelNamed:(NSString *)name;

/** Subscribes to the named presence channel.
 
 The "presence-" prefix should be excluded from the name; it will be added automatically.
 
 Whilst the presence delegate can be set on the channel after it is returned, to ensure
 events are not missed, it is advised that you call this method and specify a delegate. The
 delegate will be assigned before subscription happens.
 
 @param name The name of the channel (without the presence prefix) to subscribe to.
 @param presenceDelegate The presence delegate for this channel.
 */
- (PTPusherPresenceChannel *)subscribeToPresenceChannelNamed:(NSString *)name delegate:(id<PTPusherPresenceChannelDelegate>)presenceDelegate;

/** Unsubscribes from the specified channel.
 
 @param channel The channel to unsubscribe from.
 */
- (void)unsubscribeFromChannel:(PTPusherChannel *)channel;

/** Returns a previously subscribed channel with the given name.
 
 If the channel specified has not been subscribed to, this method will return nil.
 
 @param name The name of the channel required.
 */
- (PTPusherChannel *)channelNamed:(NSString *)name;

///------------------------------------------------------------------------------------/
/// @name Publishing events
///------------------------------------------------------------------------------------/

/** Sends an event directly over the connection's socket.
 
 Whilst Pusher provides a REST API for publishing events, it also supports the sending of
 events directly from clients over the client's existing connection.
 
 Client events have the following restrictions:

 + The user must be subscribed to the channel that the event is being triggered on.
 
 + Client events can only be triggered on private and presence channels because they require authentication.
 
 + Client events must be prefixed by client-. Events with any other prefix will be rejected by the Pusher server, as will events sent to channels to which the client is not subscribed.
 
 This method does nothing to enforce the first two restrictions. It is instead recommended that
 you use the `PTPusherChannel` event triggering API rather than calling this method directly.
 
 @warning Note: This Pusher feature is currently in beta and requires enabling on your account.
 */
- (void)sendEventNamed:(NSString *)name data:(id)data channel:(NSString *)channelName;

@end

