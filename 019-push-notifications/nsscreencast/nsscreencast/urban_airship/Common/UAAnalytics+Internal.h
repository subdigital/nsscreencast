/*
 Copyright 2009-2011 Urban Airship Inc. All rights reserved.
 
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

@interface UAAnalytics () {
    NSString *server;
    NSMutableDictionary *session;
    NSDictionary *notificationUserInfo_;
    UAHTTPConnection *connection_;
    int x_ua_max_total;
    int x_ua_max_batch;
    int x_ua_max_wait;
    int x_ua_min_batch_interval;	
	int sendInterval_;
    int databaseSize_;
    NSTimeInterval oldestEventTime;    
    NSDate *lastLocationSendTime;    
    NSTimer *sendTimer_;    
    BOOL analyticsLoggingEnabled;    
    NSString *packageVersion;
    UIBackgroundTaskIdentifier sendBackgroundTask_; 
}

@property (nonatomic, copy) NSString *server;
@property (nonatomic, retain) NSMutableDictionary *session;
@property (nonatomic, retain) NSDictionary *notificationUserInfo;
@property (nonatomic, retain) UAHTTPConnection *connection;
@property (nonatomic, assign) int x_ua_max_total;
@property (nonatomic, assign) int x_ua_max_batch;
@property (nonatomic, assign) int x_ua_max_wait;
@property (nonatomic, assign) int x_ua_min_batch_interval;
@property (nonatomic, assign, setter = setSendInterval:) int sendInterval;
@property (nonatomic, assign) int databaseSize;
@property (nonatomic, assign) NSTimeInterval oldestEventTime;
@property (nonatomic, retain) NSTimer *sendTimer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier sendBackgroundTask;


- (void)initSession;

- (void)restoreFromDefault;
- (void)saveDefault;
- (void)resetEventsDatabaseStatus;

/* Sending analytics */
- (void)send;

/* Set send interval. This has the side effect of creating a new NSTimer
 in sendTimer with the new interval. */
- (void)setSendInterval:(int)sendTimer;

/* Refresh the send timer */
- (void)setupSendTimer:(NSTimeInterval)timeInterval;
- (void)updateAnalyticsParametersWithHeaderValues:(NSHTTPURLResponse*)response;

- (BOOL)shouldSendAnalytics;
- (void)setLastSendTime:(NSDate*)lastSendTime;

/* App State */
- (void)enterForeground;
- (void)enterBackground;
- (void)didBecomeActive;
- (void)willResignActive;

/* Network connectivity */
- (void)refreshSessionWhenNetworkChanged;
- (void)refreshSessionWhenActive;

/* Invalidate the background task that will be running
 if the app has been backgrounded after being active. */
- (void)invalidateBackgroundTask;

/* Generate an analytics request with the proper fields */
- (UAHTTPRequest*)analyticsRequest;

/* Clean up event data for sending
 Enforce max batch limits
 Loop through events and discard DB-only items
 format the JSON field as a dictionary
 */
- (NSArray*)prepareEventsForUpload;


@end