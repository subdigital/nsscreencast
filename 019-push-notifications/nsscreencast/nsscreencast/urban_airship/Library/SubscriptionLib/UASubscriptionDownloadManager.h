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

#import "UADownloadManager.h"
#import "UALocalStorageDirectory.h"

#define kSubscriptionURLCacheFile [[UALocalStorageDirectory uaDirectory].path stringByAppendingPathComponent:@"/subsURLCache.plist"]

#define kPendingSubscriptionContentFile [[UALocalStorageDirectory uaDirectory].path stringByAppendingPathComponent:@"/pendingSubscriptions.history"]

#define kDecompressingSubscriptionContentFile [[UALocalStorageDirectory uaDirectory].path stringByAppendingPathComponent:@"/decompressingSubscriptions.history"]

@class UAContentURLCache;
@class UASubscriptionContent;

/**
 * This class handles subscription downloads and decompression.
 */
@interface UASubscriptionDownloadManager : NSObject <UADownloadManagerDelegate> {
  @private
    NSMutableArray *pendingSubscriptionContent;
    NSMutableArray *decompressingSubscriptionContent;
    NSMutableArray *currentlyDecompressingContent;
    UADownloadManager *downloadManager;
    NSString *downloadDirectory;
    UAContentURLCache *contentURLCache;
    BOOL createProductIDSubdir;
}

/**
 * The download directory.  If not set by the user, this will return a default value.
 */
@property (nonatomic, retain) NSString *downloadDirectory;
@property (nonatomic, retain) UAContentURLCache *contentURLCache;
/**
 * Indicates whether to create a subscription key or product ID subdirectory for downloaded content.
 * Defaults to YES.
 */
@property (nonatomic, assign) BOOL createProductIDSubdir;
@property (nonatomic, retain) NSMutableArray *pendingSubscriptionContent;
@property (nonatomic, retain) NSMutableArray *decompressingSubscriptionContent;
@property (nonatomic, retain) NSMutableArray *currentlyDecompressingContent;

//load the pending subscriptions dictionary from kPendingSubscriptionsFile
- (void)loadPendingSubscriptionContent;
- (BOOL)hasPendingSubscriptionContent:(UASubscriptionContent *)subscriptionContent;
- (void)resumePendingSubscriptionContent;

//load the decompressing subscriptions dictionary from kDecompressingSubscriptionsFile
- (void)loadDecompressingSubscriptionContent;
- (BOOL)hasDecompressingSubscriptionContent:(UASubscriptionContent *)subscriptionContent;
- (void)resumeDecompressingSubscriptionContent;

- (void)download:(UASubscriptionContent *)content;

//private library method
- (void)checkDownloading:(UASubscriptionContent *)content;

@end
