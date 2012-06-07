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

#import "UAGlobal.h"
#import "UAirship.h"
#import "UAObservable.h"

#define kEnabled @"UAPushEnabled"
#define kAlias @"UAPushAlias"
#define kTags @"UAPushTags"
#define kBadge @"UAPushBadge"
#define kQuietTime @"UAPushQuietTime"
#define kTimeZone @"UAPushTimeZone"

#define PUSH_UI_CLASS @"UAPushUI"
#define PUSH_DELEGATE_CLASS @"UAPushNotificationHandler"

UA_VERSION_INTERFACE(UAPushVersion)

/**
 * 
 *
 */
@protocol UAPushUIProtocol
+ (void)openApnsSettings:(UIViewController *)viewController
                   animated:(BOOL)animated;
+ (void)openTokenSettings:(UIViewController *)viewController //TODO: remove from lib - it's a demo feature
                   animated:(BOOL)animated;
+ (void)closeApnsSettingsAnimated:(BOOL)animated;
+ (void)closeTokenSettingsAnimated:(BOOL)animated;//TODO: remove from lib - it's a demo feature
@end

/**
 * Protocol to be implemented by push notification clients. All methods are optional.
 */
@protocol UAPushNotificationDelegate<NSObject>

@optional

/**
 * Called when an alert notification is received.
 * @param alertMessage a simple string to be displayed as an alert
 */
- (void)displayNotificationAlert:(NSString *)alertMessage;

/**
 * Called when an alert notification is received with additional localization info.
 * @param alertDict a dictionary containing the alert and localization info
 */
- (void)displayLocalizedNotificationAlert:(NSDictionary *)alertDict;

/**
 * Called when a push notification is received with a sound associated
 * @param sound the sound to play
 */
- (void)playNotificationSound:(NSString *)sound;

/**
 * Called when a push notification is received with a custom payload
 * @param notification basic information about the notification
 * @param customPayload user-defined custom payload
 */
- (void)handleNotification:(NSDictionary *)notification withCustomPayload:(NSDictionary *)customPayload;

/**
 * Called when a push notification is received with a badge number
 * @param badgeNumber the badge number to display
 */
- (void)handleBadgeUpdate:(int)badgeNumber;

/**
 * Called when a push notification is received when the application is in the background
 * @param notification the push notification
 */
- (void)handleBackgroundNotification:(NSDictionary *)notification;
@end


/**
 * 
 */
@interface UAPush : UAObservable<UARegistrationObserver> {

  @private
    id<UAPushNotificationDelegate> delegate; /* Push notification delegate. Handles incoming notifications */
    NSObject<UAPushNotificationDelegate> *defaultPushHandler; /* A default implementation of the push notification delegate */

    BOOL pushEnabled; /* Push enabled flag. */
    BOOL autobadgeEnabled;
    UIRemoteNotificationType notificationTypes; /* Requested notification types */
    NSString *alias; /* Device token alias. */
    NSMutableArray *tags; /* Device token tags */
    NSMutableDictionary *quietTime; /* Quiet time period. */
    NSString *tz; /* Timezone, for quiet time */
}

@property (nonatomic, assign) id<UAPushNotificationDelegate> delegate;
@property (nonatomic, assign) BOOL pushEnabled;
@property (nonatomic, retain) NSString *alias;
@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) NSMutableDictionary *quietTime;
@property (nonatomic, retain) NSString *tz;
@property (nonatomic, readonly) UIRemoteNotificationType notificationTypes;

SINGLETON_INTERFACE(UAPush);

/**
 * Use a custom UI implementation.
 * Replaces the default push UI, defined in UAPushUI, with
 * a custom implementation.
 *
 * @see UAPushUIProtocol
 * @see UAPushUI
 *
 * @param customUIClass An implementation of UAPushUIProtocol
 */
+ (void)useCustomUI:(Class)customUIClass;
+ (void)openApnsSettings:(UIViewController *)viewController
                animated:(BOOL)animated;
+ (void)openTokenSettings:(UIViewController *)viewController
                 animated:(BOOL)animated;
+ (void)closeApnsSettingsAnimated:(BOOL)animated;
+ (void)closeTokenSettingsAnimated:(BOOL)animated;

+ (void)land;

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;
- (void)registerDeviceToken:(NSData *)token;
- (void)updateRegistration;

// Change tags for current device token
- (void)addTagToCurrentDevice:(NSString *)tag;
- (void)removeTagFromCurrentDevice:(NSString *)tag;

// Update (replace) token attributes
- (void)updateAlias:(NSString *)value;
- (void)updateTags:(NSMutableArray *)value;

// Change quiet time for current device token, only take hh:mm into account
- (void)setQuietTimeFrom:(NSDate *)from to:(NSDate *)to withTimeZone:(NSTimeZone *)tz;
- (void)disableQuietTime;

- (void)enableAutobadge:(BOOL)enabled;
- (void)setBadgeNumber:(NSInteger)badgeNumber;
- (void)resetBadge;

//Handle incoming push notifications
- (void)handleNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state;

+ (NSString *)pushTypeString:(UIRemoteNotificationType)types;

@end
