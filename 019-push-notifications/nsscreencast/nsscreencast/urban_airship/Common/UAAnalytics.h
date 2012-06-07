/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
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
#import "UAHTTPConnection.h"

@class UAEvent;

// Used for init local size if server didn't respond, or server sends bad data

//total size in kilobytes that the event queue is allowed to grow to.
#define X_UA_MAX_TOTAL 5*1024*1024	// local max of 5MB

// total size in kilobytes that a given event post is allowed to send.
#define X_UA_MAX_BATCH 500*1024		// local max of 500kb

// maximum amount of time in seconds that events should queue for
#define X_UA_MAX_WAIT 7*24*3600		// local max of 7 days

// The actual amount of time in seconds that elapse between event-server posts
// TODO: Get with the analytics team and rename this header field
#define X_UA_MIN_BATCH_INTERVAL 60	// local min of 60s

// minimum amount of time between background location events
#define X_UA_MIN_BACKGROUND_LOCATION_INTERVAL 900 // 900 seconds = 15 minutes

// Offset time for use when the app init. This is the time between object
// creation and first upload. Subsequent uploads are defined by 
// X_UA_MIN_BATCH_INTERVAL
#define UAAnalyticsFirstBatchUploadInterval 15 // time in seconds

extern NSString * const UAAnalyticsOptionsRemoteNotificationKey;
extern NSString * const UAAnalyticsOptionsServerKey;
extern NSString * const UAAnalyticsOptionsLoggingKey;

typedef NSString UAAnalyticsValue;
extern UAAnalyticsValue * const UAAnalyticsTrueValue;
extern UAAnalyticsValue * const UAAnalyticsFalseValue;

@interface UAAnalytics : NSObject<UAHTTPConnectionDelegate> 

@property (nonatomic, copy, readonly) NSString *server;
@property (nonatomic, retain, readonly) NSMutableDictionary *session;
@property (nonatomic, assign, readonly) int databaseSize;
@property (nonatomic, assign, readonly) int x_ua_max_total;
@property (nonatomic, assign, readonly) int x_ua_max_batch;
@property (nonatomic, assign, readonly) int x_ua_max_wait;
@property (nonatomic, assign, readonly) int x_ua_min_batch_interval;
@property (nonatomic, assign, readonly) int sendInterval;
@property (nonatomic, assign, readonly) NSTimeInterval oldestEventTime;
@property (nonatomic, retain, readonly) NSTimer *sendTimer;
@property (nonatomic, assign, readonly) UIBackgroundTaskIdentifier sendBackgroundTask;
@property (nonatomic, retain, readonly) NSDictionary *notificationUserInfo;


- (id)initWithOptions:(NSDictionary *)options;
- (void)addEvent:(UAEvent *)event;
- (void)handleNotification:(NSDictionary *)userInfo;

/** This class contains an NSTimer. This timer must be invalidated before
 this class is released, or there will be a memory leak. Call invalidate
 before deallocating this class */
- (void)invalidate;

/** Date representing the last attempt to send analytics */
- (NSDate*)lastSendTime;

@end
