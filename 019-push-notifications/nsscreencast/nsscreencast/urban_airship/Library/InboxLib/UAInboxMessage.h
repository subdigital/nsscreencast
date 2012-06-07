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

@class UAInboxMessageList;

/**
 * This class represents a Rich Push Inbox message. It contains all
 * the available information about a message, including the URLs where
 * the message can be retrieved.
 */
@interface UAInboxMessage : NSObject {
  @private
    NSString *messageID;
    NSURL *messageBodyURL;
    NSURL *messageURL;
    NSString *contentType;
    BOOL unread;
    NSDate *messageSent;
    NSString *title;
    NSDictionary *extra;
    UAInboxMessageList *inbox;//not retained - see property
}


/**
 * Initialize the message.
 *
 * @param message A dictionary with keys and values conforming to the
 * Urban Airship JSON API for retrieving inbox messages.
 * @param inbox The inbox containing this message.
 *
 * @return A message, populated with data from the message dictionary.
 */
- (id)initWithDict:(NSDictionary *)message inbox:(UAInboxMessageList *)inbox;

/**
 * Mark the message as read.
 * 
 * @return YES if the request was submitted or already complete, otherwise NO.
 */
- (BOOL)markAsRead;

/**
 * Invokes the UAInbox Javascript delegate from within a message's UIWebView.
 *
 * This method returns null, but a callback to the UIWebView may be made via
 * [UIWebView stringByEvaluatingJavaScriptFromString:] if the delegate returns
 * a Javascript string for evaluation.
 *
 * @param webView The UIWebView generating the request
 * @param url The URL requested by the webView
 */
+ (void)performJSDelegate:(UIWebView *)webView url:(NSURL *)url;


///---------------------------------------------------------------------------------------
/// @name Message Properties
///---------------------------------------------------------------------------------------

/**
 * The Urban Airship message ID.
 * This ID may be used to match an incoming push notification to a specific message.
 */
@property (nonatomic, retain) NSString *messageID;

/**
 * The URL for the message body itself.
 * This URL may only be accessed with Basic Auth credentials set to the user id and password.
 */
@property (nonatomic, retain) NSURL *messageBodyURL;

/** The URL for the message.
 * This URL may only be accessed with Basic Auth credentials set to the user id and password.
 */
@property (nonatomic, retain) NSURL *messageURL;

/** The MIME content type for the message (e.g., text/html) */
@property (nonatomic, copy) NSString *contentType;

/** YES if the message is unread, otherwise NO. */
@property (assign) BOOL unread;

/** The date and time the message was sent (UTC) */
@property (nonatomic, retain) NSDate *messageSent;

/** The message title */
@property (nonatomic, retain) NSString *title;

/**
 * The message's extra dictionary. This dictionary can be populated
 * with arbitrary key-value data at the time the message is composed.
 */
@property (nonatomic, retain) NSDictionary *extra;

/**
 * The parent inbox.
 * 
 * Note that this object is not retained by the message.
 */
@property (assign) UAInboxMessageList *inbox; 

@end
