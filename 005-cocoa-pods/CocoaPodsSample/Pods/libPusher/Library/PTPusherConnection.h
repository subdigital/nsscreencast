//
//  PTPusherConnection.h
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTWebSocket.h"

@class PTPusherConnection;
@class PTPusherEvent;

@protocol PTPusherConnectionDelegate <NSObject>
- (void)pusherConnectionDidConnect:(PTPusherConnection *)connection;
- (void)pusherConnectionDidDisconnect:(PTPusherConnection *)connection;
- (void)pusherConnection:(PTPusherConnection *)connection didFailWithError:(NSError *)error;
- (void)pusherConnection:(PTPusherConnection *)connection didReceiveEvent:(PTPusherEvent *)event;
@end

@interface PTPusherConnection : NSObject <ZTWebSocketDelegate> {
  ZTWebSocket *socket;
}
@property (nonatomic, unsafe_unretained) id<PTPusherConnectionDelegate> delegate;
@property (nonatomic, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, copy, readonly) NSString *socketID;

///------------------------------------------------------------------------------------/
/// @name Initialisation
///------------------------------------------------------------------------------------/

/** Creates a new PTPusherConnection instance.
 
 Connections are not opened immediately; an explicit call to connect is required.
 
 @param aURL      The websocket endpoint
 @param delegate  The delegate for this connection
 @param secure    Whether this connection should be secure (TLS)
 */
- (id)initWithURL:(NSURL *)aURL secure:(BOOL)secure;

///------------------------------------------------------------------------------------/
/// @name Managing connections
///------------------------------------------------------------------------------------/

/** Establishes a web socket connection to the Pusher server.
 
 The delegate will only be sent a didConnect message when the web socket receives a 
 'connection_established' event from Pusher, regardless of the web socket's connection state.
 */
- (void)connect;

/** Closes the web socket connection */
- (void)disconnect;

///------------------------------------------------------------------------------------/
/// @name Sending data
///------------------------------------------------------------------------------------/

/** Sends an object over the web socket connection.
 
 The object will be serialized to JSON before sending, so the object must be anything
 that can be converted into JSON (typically, any plist compatible object).
 */
- (void)send:(id)object;

@end
