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

@class UA_ASIHTTPRequest;

@interface UAUtils : NSObject {

}

///---------------------------------------------------------------------------------------
/// @name Digest/Hash Utils
///---------------------------------------------------------------------------------------

+ (NSString *)md5:(NSString *)sourceString;

///---------------------------------------------------------------------------------------
/// @name Device ID Utils
///---------------------------------------------------------------------------------------

+ (NSString *)UUID;

+ (NSString *)deviceModelName;

/**
 * Gets the Urban Airship Device ID.
 *
 * @return The device ID, or an empty string if the ID cannot be retrieved or created.
 */
+ (NSString *)deviceID;

///---------------------------------------------------------------------------------------
/// @name URL Encoding
///---------------------------------------------------------------------------------------

+ (NSString *)urlEncodedStringWithString:(NSString *)string encoding:(NSStringEncoding)encoding;


///---------------------------------------------------------------------------------------
/// @name HTTP Authenticated Request Helpers
///---------------------------------------------------------------------------------------

+ (UA_ASIHTTPRequest *)userRequestWithURL:(NSURL *)url method:(NSString *)method
                                 delegate:(id)delegate finish:(SEL)selector;

+ (UA_ASIHTTPRequest *)userRequestWithURL:(NSURL *)url method:(NSString *)method
                                 delegate:(id)delegate finish:(SEL)sel1 fail:(SEL)sel2;

+ (UA_ASIHTTPRequest *)requestWithURL:(NSURL *)url method:(NSString *)method
                             delegate:(id)delegate finish:(SEL)selector;

+ (UA_ASIHTTPRequest *)requestWithURL:(NSURL *)url method:(NSString *)method
                             delegate:(id)delegate finish:(SEL)sel1 fail:(SEL)sel2;

/**
 * Returns a basic auth header string.
 *
 * The return value takes the form of: `Basic [Base64 Encoded "username:password"]`
 *
 * @return An HTTP Basic Auth header string value for the user's credentials.
 */
+ (NSString *)userAuthHeaderString;

///---------------------------------------------------------------------------------------
/// @name HTTP Response Helpers
///---------------------------------------------------------------------------------------
+ (id)responseFromRequest:(UA_ASIHTTPRequest *)request;
+ (id)parseJSON:(NSString *)responseString;
+ (void)requestWentWrong:(UA_ASIHTTPRequest *)request;
+ (void)requestWentWrong:(UA_ASIHTTPRequest *)request keyword:(NSString *)keyword;

///---------------------------------------------------------------------------------------
/// @name UI Formatting Helpers
///---------------------------------------------------------------------------------------

+ (NSString *)pluralize:(int)count 
           singularForm:(NSString*)singular
             pluralForm:(NSString*)plural;

+ (NSString *)getReadableFileSizeFromBytes:(double)bytes;

@end
