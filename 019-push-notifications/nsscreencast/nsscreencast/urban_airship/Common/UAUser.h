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
#import "UAObservable.h"

@class UA_ASIHTTPRequest;

typedef enum _UAUserState {
    UAUserStateEmpty = 0,
    UAUserStateNoEmail = 1,
    UAUserStateWithEmail = 2,
    UAUserStateInRecovery = 3,
    UAUserStateCreating = 4
} UAUserState;

@protocol UAUserObserver <NSObject>
@optional

// Notified when user created or modified, not including recovery
- (void)userUpdated;
- (void)userUpdateFailed;

// Notified during recovering process
- (void)userRecoveryStarted;
- (void)userRecoveryFinished;
- (void)userRecoveryFailed;

- (void)userRetrieveStarted;
- (void)userRetrieveFinished;
- (void)userRetrieveFailed;
@end

@interface UAUser : UAObservable {

  @private
    BOOL initialized;
    NSString *username;
    NSString *password;
    NSString *email;
    NSString *url;
    NSString *alias;
    NSMutableSet *tags;
    
    UAUserState userState;
    
    //recovery
    NSString *recoveryEmail;
    NSString *recoveryStatusUrl;
    NSTimer *recoveryPoller;
    BOOL inRecovery;
    BOOL recoveryStarted;
    BOOL sentRecoveryEmail;
    BOOL retrievingUser;
    
    BOOL isObservingDeviceToken;
    
    //creation flag
    BOOL creatingUser;

}

@property (retain, nonatomic) NSString *recoveryEmail;
@property (retain, nonatomic) NSString *recoveryStatusUrl;
@property (retain, nonatomic) NSTimer *recoveryPoller;

// Public interface
@property (assign, readonly, nonatomic) UAUserState userState;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *alias;
@property (retain, nonatomic) NSMutableSet *tags;

+ (UAUser *)defaultUser;
+ (void)land;

- (BOOL)defaultUserCreated;
- (BOOL)setUserEmail:(NSString *)address;
- (void)startRecovery;
- (void)cancelRecovery;

// Private interface
@property (assign, nonatomic) BOOL inRecovery;
@property (assign, nonatomic) BOOL recoveryStarted;
@property (assign, nonatomic) BOOL sentRecoveryEmail;
@property (assign, nonatomic) BOOL retrievingUser;

//Specifies a default PRE-EXISTING username and password to use in the case a new user would 
//otherwise be created by [UAUser defaultUser]
+ (void)setDefaultUsername:(NSString *)defaultUsername withPassword:(NSString *)defaultPassword;

- (void)initializeUser;
- (void)loadUser;

- (void)createUser;
- (void)createUserWithEmail:(NSString *)value;
- (void)modifyUserWithEmail:(NSString *)value;

- (void)retrieveUser;

- (void)startRecoveryPoller;
- (void)stopRecoveryPoller;
- (void)checkRecoveryStatus:(NSTimer *)timer;

- (void)didMergeWithUser:(NSDictionary *)userData;

- (void)saveUserData;
- (void)updateUserState;
- (void)notifyObserversUserUpdated;

- (void)requestWentWrong:(UA_ASIHTTPRequest*)request;
- (void)userRequestWentWrong:(UA_ASIHTTPRequest*)request;

//POST
- (void)updateUserInfo:(NSDictionary *)info withDelegate:(id)delegate finish:(SEL)finishSelector fail:(SEL)failSelector;

//PUT
- (void)updateUserWithDelegate:(id)delegate finish:(SEL)finishSelector fail:(SEL)failSelector;
- (NSMutableDictionary*)createUserDictionary;

@end