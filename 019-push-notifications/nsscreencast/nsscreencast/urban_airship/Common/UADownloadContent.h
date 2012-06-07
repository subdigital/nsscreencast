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
#import <StoreKit/StoreKit.h>

#define kRequestMethodGET @"GET"
#define kRequestMethodPOST @"POST"
#define kMaxRetryTime 3

@interface UADownloadContent : NSObject {
    id userInfo;
    id progressDelegate;
    BOOL clearBeforeDownload;

    NSString *username;
    NSString *password;

    NSString *downloadFileName;
    NSURL *downloadRequestURL;
    
    NSString *downloadPath;
    NSString *downloadTmpPath;
    
    NSDictionary *postData;
    NSString *requestMethod; 
    NSString *responseString;

}
@property (assign, nonatomic) id progressDelegate;
@property (retain, nonatomic) id userInfo;
@property (assign, nonatomic) BOOL clearBeforeDownload;

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSURL *downloadRequestURL;
@property (retain, nonatomic) NSString *downloadFileName;
@property (retain, nonatomic) NSString *requestMethod;
@property (retain, nonatomic) NSString *responseString;
@property (retain, nonatomic) NSString *downloadPath;
@property (retain, nonatomic) NSString *downloadTmpPath;
@property (retain, nonatomic) NSDictionary *postData;

@end

@class UAZipDownloadContent;
@protocol UAZipDownloadContentProtocol <NSObject>
@optional
- (void)decompressDidSucceed:(UAZipDownloadContent *)zipDownloadContent;
- (void)decompressDidFail:(UAZipDownloadContent *)zipDownloadContent;
@end

@interface UAZipDownloadContent : UADownloadContent {
    id<UAZipDownloadContentProtocol> decompressDelegate;
    
    @private
      NSString *decompressedContentPath;
}
@property (assign, nonatomic) id decompressDelegate;
@property (retain, nonatomic) NSString *decompressedContentPath;

- (void)decompress;
@end

