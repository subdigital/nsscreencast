/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

#import "UAInboxMessageListObserver.h"

@class UAInboxMessageList;

/**
 * This protocol defines a delegate method that is called
 * when a push notification arrives with a rich push message ID
 * embedded in its payload.
 */
@protocol UAInboxPushHandlerDelegate <NSObject>

@required
/**
 * Handle an incoming push message.
 * @param message An NSDictionary with the push notification contents.
 */
- (void)newMessageArrived:(NSDictionary *)message;
@end

/**
 * This class handles incoming rich push messages that are sent with
 * an APNS notification.
 */
@interface UAInboxPushHandler : NSObject <UAInboxMessageListObserver> {
  @private
    NSString *viewingMessageID;
    id <UAInboxPushHandlerDelegate> delegate;
	BOOL hasLaunchMessage;
}

/**
 * Handle an incoming in-app notification.  This should typically be called 
 * from the UIApplicationDelegate.
 * @param userInfo the notification as an NSDictionary
 */
+ (void)handleNotification:(NSDictionary*)userInfo;

/**
 * Handle the launch options passed in as the app starts, while will include
 * a noficiation if the app was launched in response to viewing one.  This should
 * typically be called from the UIApplicationDelegate.
 * @param options The launch options asn an NSDictionary.
 */
+ (void)handleLaunchOptions:(NSDictionary*)options;

/**
 * The message ID of the most recent rich push as an NSString.
 */
@property (nonatomic, retain) NSString *viewingMessageID;

/**
 * YES if the most recent rich push launched the app, NO otherwise.
 */
@property (nonatomic, assign) BOOL hasLaunchMessage;

/**
 * The delegate that should be notified when an incoming push is handled,
 * as an object conforming to the UAInboxPushHandlerDelegate protocol.
 * NOTE: The delegate is not retained.
 */
@property (nonatomic, assign) id <UAInboxPushHandlerDelegate> delegate;

@end