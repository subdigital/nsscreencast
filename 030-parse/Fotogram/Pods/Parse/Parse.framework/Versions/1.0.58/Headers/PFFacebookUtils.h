//
// PFFacebookUtils.h
// Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PF_Facebook.h"
#import "PFUser.h"
#import "PFConstants.h"

/*!
 Provides utility functions for working with Facebook in a Parse application.
 */
@interface PFFacebookUtils : NSObject

/** @name Interacting With Facebook */

/*!
 Gets the instance of the Facebook object (from the Facebook SDK) that Parse uses. 
 @result The Facebook instance.
 */
+ (PF_Facebook *)facebook;

/*!
 Gets the instance of the Facebook object (from the Facebook SDK) that Parse uses. 
 @param delegate Specify your own delegate for the Facebook object.
 @result The Facebook instance
 */
+ (PF_Facebook *)facebookWithDelegate:(NSObject<PF_FBSessionDelegate> *)delegate;

/*!
 Initializes the Facebook singleton. You must invoke this in order to use the Facebook functionality in Parse.
 @param appId The Facebook application id that you are using with your Parse application.
 */
+ (void)initializeWithApplicationId:(NSString *)appId;

/*!
 Whether the user has their account linked to Facebook.
 @param user User to check for a facebook link. The user must be logged in on this device.
 @result True if the user has their account linked to Facebook.
 */
+ (BOOL)isLinkedWithUser:(PFUser *)user;

/** @name Logging In & Creating Facebook-Linked Users */

/*!
 Logs in a user using Facebook. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically logs in (or creates, in the case where it is a new user)
 a PFUser.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param block The block to execute. The block should have the following argument signature:
 (PFUser *user, NSError *error) 
 */
+ (void)logInWithPermissions:(NSArray *)permissions block:(PFUserResultBlock)block;

/*!
 Logs in a user using Facebook. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically logs in (or creates, in the case where it is a new user)
 a PFUser. The selector for the callback should look like: (PFUser *)user error:(NSError **)error
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete.
 */
+ (void)logInWithPermissions:(NSArray *)permissions target:(id)target selector:(SEL)selector;

/*!
 Logs in a user using Facebook. Allows you to handle user login to Facebook, then provide authentication
 data to log in (or create, in the case where it is a new user) the PFUser.
 @param facebookId The id of the Facebook user being linked
 @param accessToken The access token for the user's session
 @param expirationDate The expiration date for the access token
 @param block The block to execute. The block should have the following argument signature:
 (PFUser *user, NSError *error) 
 */
+ (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
             expirationDate:(NSDate *)expirationDate
                      block:(PFUserResultBlock)block;

/*!
 Logs in a user using Facebook. Allows you to handle user login to Facebook, then provide authentication
 data to log in (or create, in the case where it is a new user) the PFUser.
 The selector for the callback should look like: (PFUser *)user error:(NSError *)error
 @param facebookId The id of the Facebook user being linked
 @param accessToken The access token for the user's session
 @param expirationDate The expiration date for the access token
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete
 */
+ (void)logInWithFacebookId:(NSString *)facebookId
                accessToken:(NSString *)accessToken
             expirationDate:(NSDate *)expirationDate
                     target:(id)target
                   selector:(SEL)selector;

/** @name Linking Users with Facebook */

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions;

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param block The block to execute. The block should have the following argument signature:
 (BOOL *success, NSError *error) 
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions block:(PFBooleanResultBlock)block;

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 The selector for the callback should look like: (NSNumber *)result error:(NSError *)error
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete.
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions target:(id)target selector:(SEL)selector;

/*!
 Links Facebook to an existing PFUser. Allows you to handle user login to Facebook, then provide authentication
 data to link the account to the PFUser.
 @param user User to link to Facebook.
 @param facebookId The id of the Facebook user being linked
 @param accessToken The access token for the user's session
 @param expirationDate The expiration date for the access token
 @param block The block to execute. The block should have the following argument signature:
 (BOOL *success, NSError *error) 
 */
+ (void)linkUser:(PFUser *)user
      facebookId:(NSString *)facebookId
     accessToken:(NSString *)accessToken
  expirationDate:(NSDate *)expirationDate
           block:(PFBooleanResultBlock)block;

/*!
 Links Facebook to an existing PFUser. Allows you to handle user login to Facebook, then provide authentication
 data to link the account to the PFUser.
 The selector for the callback should look like: (NSNumber *)result error:(NSError *)error
 @param user User to link to Facebook.
 @param facebookId The id of the Facebook user being linked
 @param accessToken The access token for the user's session
 @param expirationDate The expiration date for the access token
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete
 */
+ (void)linkUser:(PFUser *)user
      facebookId:(NSString *)facebookId
     accessToken:(NSString *)accessToken
  expirationDate:(NSDate *)expirationDate
          target:(id)target
        selector:(SEL)selector;

/** @name Unlinking Users from Facebook */

/*!
 Unlinks the PFUser from a Facebook account. 
 @param user User to unlink from Facebook.
 @result Returns true if the unlink was successful.
 */
+ (BOOL)unlinkUser:(PFUser *)user;

/*!
 Unlinks the PFUser from a Facebook account. 
 @param user User to unlink from Facebook.
 @param error Error object to set on error.
 @result Returns true if the unlink was successful.
 */
+ (BOOL)unlinkUser:(PFUser *)user error:(NSError **)error;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook.
 */
+ (void)unlinkUserInBackground:(PFUser *)user;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
+ (void)unlinkUserInBackground:(PFUser *)user block:(PFBooleanResultBlock)block;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete.
 */
+ (void)unlinkUserInBackground:(PFUser *)user target:(id)target selector:(SEL)selector;

/** @name Extending Facebook Access Tokens */

/*!
 Whether the user has a Facebook access token that needs to be extended.
 @param user User that is linked to Facebook and should be checked for access token extension.
 @result True if the access token needs to be extended.
 */
+ (BOOL)shouldExtendAccessTokenForUser:(PFUser *)user;

/*!
 Extends the access token for a user using Facebook, and saves the refreshed access token back to the PFUser.
 The selector for the callback should look like: (NSNumber *)result error:(NSError *)error
 @param user User whose access token should be extended
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete.
 */
+ (void)extendAccessTokenForUser:(PFUser *)user target:(id)target selector:(SEL)selector;

/*!
 Extends the access token for a user using Facebook, and saves the refreshed access token back to the PFUser.
 @param user User whose access token should be extended
 @param block The block to execute. The block should have the following argument signature:
 (BOOL success, NSError *error) 
 */
+ (void)extendAccessTokenForUser:(PFUser *)user block:(PFBooleanResultBlock)block;

/*!
 If necessary, extends the access token for a user using Facebook, and saves the refreshed 
 access token back to the PFUser.  We recommend invoking this from applicationDidBecomeActive: in your AppDelegate.
 The selector for the callback should look like: (NSNumber *)result error:(NSError *)error
 @param user User whose access token should be extended
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchronous request is complete.
 @result True if the access token needed to be extended.
 */
+ (BOOL)extendAccessTokenIfNeededForUser:(PFUser *)user target:(id)target selector:(SEL)selector;

/*!
 If necessary, extends the access token for a user using Facebook, and saves the refreshed 
 access token back to the PFUser.  We recommend invoking this from applicationDidBecomeActive: in your AppDelegate.
 @param user User whose access token should be extended
 @param block The block to execute. The block should have the following argument signature:
 (BOOL success, NSError *error) 
 @result True if the access token needed to be extended.
 */
+ (BOOL)extendAccessTokenIfNeededForUser:(PFUser *)user block:(PFBooleanResultBlock)block;

/** @name Delegating URL Actions */

/*!
 Handles URLs being opened by your AppDelegate. Invoke and return this from application:handleOpenURL:
 or application:openURL:sourceApplication:annotation in your AppDelegate.
 @param url URL being opened by your application.
 @result True if Facebook will handle this URL.
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
