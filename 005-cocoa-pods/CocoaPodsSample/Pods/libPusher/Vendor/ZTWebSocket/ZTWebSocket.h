//
//  ZTWebSocket.h
//  Zimt
//
//  Created by Esad Hajdarevic on 2/14/10.
//  Copyright 2010 OpenResearch Software Development OG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncSocket;
@class ZTWebSocket;

@protocol ZTWebSocketDelegate<NSObject>
@optional 
    - (void)webSocket:(ZTWebSocket*)webSocket didFailWithError:(NSError*)error;
    - (void)webSocketDidOpen:(ZTWebSocket*)webSocket;
    - (void)webSocketDidClose:(ZTWebSocket*)webSocket;
    - (void)webSocket:(ZTWebSocket*)webSocket didReceiveMessage:(NSString*)message;
    - (void)webSocketDidSendMessage:(ZTWebSocket*)webSocket;
@end

@interface ZTWebSocket : NSObject {
    id<ZTWebSocketDelegate> __unsafe_unretained delegate;
    NSURL* url;
    AsyncSocket* socket;
    BOOL connected;
    NSString* origin;
    
    NSArray* runLoopModes;
  
    // Whether to secure the socket. Event though by convension port 80 is used for unsecure connections while 443 is used for 
    // secure connections, ZTWebSocket doesn't make any assumptions based on the port number and requests that you 
    // specifically configure it to enable or disable secure sockets. 
    BOOL secureSocket;
}

@property(nonatomic,unsafe_unretained) id<ZTWebSocketDelegate> delegate;
@property(nonatomic,readonly) NSURL* url;
@property(nonatomic,strong) NSString* origin;
@property(nonatomic,readonly) BOOL connected;
@property(nonatomic,strong) NSArray* runLoopModes;

+ (id)webSocketWithURLString:(NSString*)urlString delegate:(id<ZTWebSocketDelegate>)delegate secure:(BOOL)secure;
- (id)initWithURLString:(NSString*)urlString delegate:(id<ZTWebSocketDelegate>)delegate secure:(BOOL)secure;

- (void)open;
- (void)close;
- (void)send:(NSString*)message;

@end

enum {
    ZTWebSocketErrorConnectionFailed = 1,
    ZTWebSocketErrorHandshakeFailed = 2
};

extern NSString *const ZTWebSocketException;
extern NSString* const ZTWebSocketErrorDomain;
