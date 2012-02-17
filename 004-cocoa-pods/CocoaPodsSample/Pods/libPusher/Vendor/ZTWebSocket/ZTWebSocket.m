//
//  ZTWebSocket.m
//  Zimt
//
//  Created by Esad Hajdarevic on 2/14/10.
//  Copyright 2010 OpenResearch Software Development OG. All rights reserved.
//

#import "ZTWebSocket.h"
#import "AsyncSocket.h"


NSString* const ZTWebSocketErrorDomain = @"ZTWebSocketErrorDomain";
NSString* const ZTWebSocketException = @"ZTWebSocketException";

enum {
    ZTWebSocketTagHandshake = 0,
    ZTWebSocketTagMessage = 1
};

@implementation ZTWebSocket

@synthesize delegate, url, origin, connected, runLoopModes;

#pragma mark Initializers

+ (id)webSocketWithURLString:(NSString*)urlString delegate:(id<ZTWebSocketDelegate>)aDelegate  secure:(BOOL)secure{
    return [[ZTWebSocket alloc] initWithURLString:urlString delegate:aDelegate secure:secure];
}

-(id)initWithURLString:(NSString *)urlString delegate:(id<ZTWebSocketDelegate>)aDelegate  secure:(BOOL)secure{
    if (self=[super init]) {
        self.delegate = aDelegate;
        secureSocket = secure;
        url = [NSURL URLWithString:urlString];
        if (![url.scheme hasPrefix:@"ws"]) {
            [NSException raise:ZTWebSocketException format:[NSString stringWithFormat:@"Unsupported protocol %@",url.scheme]];
        }
        socket = [[AsyncSocket alloc] initWithDelegate:self];
        self.runLoopModes = [NSArray arrayWithObjects:NSRunLoopCommonModes, nil]; 
    }
    return self;
}

#pragma mark Delegate dispatch methods

-(void)_dispatchFailure:(NSNumber*)code {
    if(delegate && [delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) {
        [delegate webSocket:self didFailWithError:[NSError errorWithDomain:ZTWebSocketErrorDomain code:[code intValue] userInfo:nil]];
    }
}

-(void)_dispatchClosed {
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidClose:)]) {
        [delegate webSocketDidClose:self];
    }
}

-(void)_dispatchOpened {
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [delegate webSocketDidOpen:self];
    }
}

-(void)_dispatchMessageReceived:(NSString*)message {
    if (delegate && [delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
        [delegate webSocket:self didReceiveMessage:message];
    }
}

-(void)_dispatchMessageSent {
    if (delegate && [delegate respondsToSelector:@selector(webSocketDidSendMessage:)]) {
        [delegate webSocketDidSendMessage:self];
    }
}

#pragma mark Private

-(void)_readNextMessage {
    [socket readDataToData:[NSData dataWithBytes:"\xFF" length:1] withTimeout:-1 tag:ZTWebSocketTagMessage];
}

#pragma mark Public interface

-(void)close {
    [socket disconnectAfterWriting];
}

-(void)open {
    if (!connected) {
        [socket connectToHost:url.host onPort:[url.port intValue] withTimeout:5 error:nil];
        if (runLoopModes) [socket setRunLoopModes:runLoopModes];
        if (secureSocket) [socket startTLS:nil];
    }
}

-(void)send:(NSString*)message {
    NSMutableData* data = [NSMutableData data];
    [data appendBytes:"\x00" length:1];
    [data appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendBytes:"\xFF" length:1];
    [socket writeData:data withTimeout:-1 tag:ZTWebSocketTagMessage];
}

#pragma mark AsyncSocket delegate methods

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    connected = NO;
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    if (!connected) {
        [self _dispatchFailure:[NSNumber numberWithInt:ZTWebSocketErrorConnectionFailed]];
    } else {
        [self _dispatchClosed];
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSString* requestOrigin = self.origin;
    if (!requestOrigin) requestOrigin = [NSString stringWithFormat:@"http://%@",url.host];
        
    NSString *requestPath = url.path;
    if (url.query) {
      requestPath = [requestPath stringByAppendingFormat:@"?%@", url.query];
    }
    NSString* getRequest = [NSString stringWithFormat:@"GET %@ HTTP/1.1\r\n"
                                                       "Upgrade: WebSocket\r\n"
                                                       "Connection: Upgrade\r\n"
                                                       "Host: %@\r\n"
                                                       "Origin: %@\r\n"
                                                       "\r\n",
                                                        requestPath,url.host,requestOrigin];
    [socket writeData:[getRequest dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:ZTWebSocketTagHandshake];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if (tag == ZTWebSocketTagHandshake) {
        [sock readDataToData:[@"\r\n\r\n" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:ZTWebSocketTagHandshake];
    } else if (tag == ZTWebSocketTagMessage) {
        [self _dispatchMessageSent];
    }
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag == ZTWebSocketTagHandshake) {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if ([response hasPrefix:@"HTTP/1.1 101 Web Socket Protocol Handshake\r\nUpgrade: WebSocket\r\nConnection: Upgrade\r\n"]) {
            connected = YES;
            [self _dispatchOpened];
            
            [self _readNextMessage];
        } else {
            [self _dispatchFailure:[NSNumber numberWithInt:ZTWebSocketErrorHandshakeFailed]];
        }
    } else if (tag == ZTWebSocketTagMessage) {
        char firstByte = 0xFF;
        [data getBytes:&firstByte length:1];
        if (firstByte != 0x00) return; // Discard message
        NSString* message = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, [data length]-2)] encoding:NSUTF8StringEncoding];
    
        [self _dispatchMessageReceived:message];
        [self _readNextMessage];
    }
}

#pragma mark Destructor

-(void)dealloc {
    socket.delegate = nil;
    [socket disconnect];
}

@end

