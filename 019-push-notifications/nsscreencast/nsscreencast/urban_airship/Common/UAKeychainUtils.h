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

#define kUAKeychainDeviceIDKey @"com.urbanairship.deviceID"

@interface UAKeychainUtils : NSObject {
	
}

+ (BOOL)createKeychainValueForUsername:(NSString *)username 
						withPassword:(NSString *)password 
						forIdentifier:(NSString *)identifier;
+ (void)deleteKeychainValue:(NSString *)identifier;
+ (BOOL)updateKeychainValueForUsername:(NSString *)username 
						withPassword:(NSString *)password
                        withEmailAddress:(NSString *)password
						forIdentifier:(NSString *)identifier;

+ (NSString *)getPassword:(NSString *)identifier;
+ (NSString *)getUsername:(NSString *)identifier;
+ (NSString *)getEmailAddress:(NSString *)identifier;

/**
 * Gets the device ID, creating or refreshing if necessary. Device IDs will be regenerated if a
 * device change is detected (though UAUser IDs remain the same in that case).
 *
 * @return The Urban Airship device ID or an empty string if an error occurred.
 */
+ (NSString *)getDeviceID;

@end
