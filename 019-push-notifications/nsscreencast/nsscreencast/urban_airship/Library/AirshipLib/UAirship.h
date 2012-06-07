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
#import "UAObservable.h"

@class UAAnalytics;
@class UA_ASIHTTPRequest;
@class UALocationService;

UA_VERSION_INTERFACE(AirshipVersion)

/**
 * Key for the default preferences dictionary that 
 * is loaded into NSUserDefaults on start for location services
 */
extern NSString * const UALocationServicePreferences;

/**
 * The takeOff options key for setting custom AirshipConfig options. The value
 * must be an NSDictionary.
 */
extern NSString * const UAirshipTakeOffOptionsAirshipConfigKey;

/**
 * The takeOff options key for passing in the options dictionary provided
 * by [UIApplication application:didFinishLaunchingWithOptions]. This key/value
 * pair should always be included in the takeOff options.
 */
extern NSString * const UAirshipTakeOffOptionsLaunchOptionsKey;

/**
 * The takeOff options key for setting custom analytics options. The value must be
 * an NSDictionary with keys for UAAnalytics. This value is typically not used.
 */
extern NSString * const UAirshipTakeOffOptionsAnalyticsKey;

/**
 * The takeOff options key for setting a pre-exising UAUAser username. The value must be
 * an NSString.
 */
extern NSString * const UAirshipTakeOffOptionsDefaultUsernameKey;

/**
 * The takeOff options key for setting a pre-exising UAUser password. The value must be
 * an NSString.
 */
extern NSString * const UAirshipTakeOffOptionsDefaultPasswordKey;

/**
 * Implement this protocol and register with the UAirship shared instance to receive
 * device token registration success and failure callbacks.
 */
@protocol UARegistrationObserver
@optional
- (void)registerDeviceTokenSucceeded;
- (void)registerDeviceTokenFailed:(UA_ASIHTTPRequest *)request;
- (void)unRegisterDeviceTokenSucceeded;
- (void)unRegisterDeviceTokenFailed:(UA_ASIHTTPRequest *)request;
- (void)addTagToDeviceSucceeded;
- (void)addTagToDeviceFailed:(UA_ASIHTTPRequest *)request;
- (void)removeTagFromDeviceSucceeded;
- (void)removeTagFromDeviceFailed:(UA_ASIHTTPRequest *)request;
@end

/**
 * UAirship manages the shared state for all Urban Airship services. [UAirship takeOff:] should be
 * called from [UIApplication application:didFinishLaunchingWithOptions] to initialize the shared
 * instance.
 */
@interface UAirship : UAObservable {
    
  @private
    NSString *server;
    NSString *appId;
    NSString *appSecret;

    NSString *deviceToken;
    BOOL deviceTokenHasChanged;
    BOOL ready;
    
}

/**
 * The current APNS/remote notification device token.
 */
@property (nonatomic, copy) NSString *deviceToken;

/**
 * The shared analytics manager. There are not currently any user-defined events,
 * so this is for internal library use only at this time.
 */
@property (nonatomic, retain) UAAnalytics *analytics;

/**
 * The Urban Airship API server. Defaults to https://device-api.urbanairship.com.
 */
@property (nonatomic, copy) NSString *server;

/**
 * The current Urban Airship app key. This value is loaded from the AirshipConfig.plist file or
 * an NSDictionary passed in to [UAAirship takeOff:] with the
 * UAirshipTakeOffOptionsAirshipConfigKey. If APP_STORE_OR_AD_HOC_BUILD is set to YES, the value set
 * in PRODUCTION_APP_KEY will be used. If APP_STORE_OR_AD_HOC_BUILD is set to NO, the value set in
 * DEVELOPMENT_APP_KEY will be used.
 */
@property (nonatomic, copy) NSString *appId;

/**
 * The current Urban Airship app secret. This value is loaded from the AirshipConfig.plist file or
 * an NSDictionary passed in to [UAAirship takeOff:] with the
 * UAirshipTakeOffOptionsAirshipConfigKey. If APP_STORE_OR_AD_HOC_BUILD is set to YES, the value set
 * in PRODUCTION_APP_SECRET will be used. If APP_STORE_OR_AD_HOC_BUILD is set to NO, the value set in
 * DEVELOPMENT_APP_SECRET will be used.
 */
@property (nonatomic, copy) NSString *appSecret;

/**
 * This flag is set to YES if the device token has been updated. It is intended for use by
 * UAUser and should not be used by implementing applications. To receive updates when the
 * device token changes, applications should implement a UARegistrationObserver.
 */
@property (nonatomic, assign) BOOL deviceTokenHasChanged;

/**
 * This flag is set to YES if the shared instance of
 * UAirship has been initialized and is ready for use.
 */
@property (nonatomic, assign) BOOL ready;

///---------------------------------------------------------------------------------------
/// @name Location Services
///---------------------------------------------------------------------------------------

@property (nonatomic, retain, getter = locationService) UALocationService *locationService;
- (UALocationService*)locationService;

///---------------------------------------------------------------------------------------
/// @name Logging
///---------------------------------------------------------------------------------------

/**
 * Enables or disables logging. Logging is enabled by default, but it will be disabled when the 
 * APP_STORE_OR_AD_HOC_BUILD AirshipConfig flag is set to YES. This flag overrides the
 * AirshipConfig settings.
 *
 * @param enabled If YES, console logging is enabled.
 */
+ (void)setLogging:(BOOL)enabled;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 * Initializes UAirship and performs all necessary setup. This creates the shared instance, loads
 * configuration values, initializes the analytics/reporting
 * module and creates a UAUser if one does not already exist.
 * 
 * This method must be called from your application delegate's
 * application:didFinishLaunchingWithOptions: method, and it may be called
 * only once. The options passed in on launch must be included in this method's options
 * parameter with the UAirshipTakeOffOptionsLaunchOptionsKey.
 *
 * Configuration are read from the AirshipConfig.plist file. You may overrride the
 * AirshipConfig.plist values at runtime by including an NSDictionary containing the override
 * values with the UAirshipTakeOffOptionsAirshipConfigKey.
 *
 * @see UAirshipTakeOffOptionsAirshipConfigKey
 * @see UAirshipTakeOffOptionsLaunchOptionsKey
 * @see UAirshipTakeOffOptionsAnalyticsKey
 * @see UAirshipTakeOffOptionsDefaultUsernameKey
 * @see UAirshipTakeOffOptionsDefaultPasswordKey
 *
 * @param options An NSDictionary containing UAirshipTakeOffOptions[...] keys and values. This
 * dictionary must contain the launch options.
 *
 */
+ (void)takeOff:(NSDictionary *)options;

/**
 * Perform teardown on the shared instance. This should be called when an application
 * terminates.
 */
+ (void)land;

/**
 * Returns the shared UAirship instance. This will raise an exception
 * if [UAirship takeOff:] has not been called.
 *
 * @return The shared UAirship instance.
 */
+ (UAirship *)shared;

///---------------------------------------------------------------------------------------
/// @name APNS Device Token Registration
///---------------------------------------------------------------------------------------

/**
 * Register a device token with UA. This will register a device token without an alias or tags.
 * If an alias is set on the device token, it will be removed. Tags will not be changed.
 *
 * Add a UARegistrationObserver to UAirship to receive success or failure callbacks.
 *
 * @param token The device token to register.
 */
- (void)registerDeviceToken:(NSData *)token;

/**
 * Register the current device token with UA.
 *
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 *
 * Add a UARegistrationObserver to UAirship to receive success or failure callbacks.
 */
- (void)registerDeviceTokenWithExtraInfo:(NSDictionary *)info;

/**
 * Register a device token and alias with UA.  An alias should only have a small
 * number (< 10) of device tokens associated with it. Use the tags API for arbitrary
 * groupings.
 *
 * Add a UARegistrationObserver to UAirship to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param alias The alias to register for this device token.
 */
- (void)registerDeviceToken:(NSData *)token withAlias:(NSString *)alias;

/**
 * Register a device token with a custom API payload.
 *
 * Add a UARegistrationObserver to UAirship to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 */
- (void)registerDeviceToken:(NSData *)token withExtraInfo:(NSDictionary *)info;

/**
 * Remove this device token's registration from the server.
 * This call is equivalent to an API DELETE call, as described here:
 * http://urbanairship.com/docs/push.html#registration
 *
 * Add a UARegistrationObserver to UAirship to receive success or failure callbacks.
 */
- (void)unRegisterDeviceToken;

/** 
 * Creates persistent default storage if necessary
 */
+ (void)registerNSUserDefaults;

@end
