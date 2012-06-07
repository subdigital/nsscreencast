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
#import "UALocalStorageDirectory.h"

#define kUADirectory [UALocalStorageDirectory uaDirectory].path

#define kUADownloadDirectory [[UALocalStorageDirectory uaDirectory] subDirectoryWithPathComponent:@"/downloads"]

#define kDownloadHistoryFile [[UALocalStorageDirectory uaDirectory].path stringByAppendingPathComponent:@"/download.history"]

@class UA_ASINetworkQueue;
@class UADownloadContent;

@protocol UADownloadManagerDelegate <NSObject>
@optional
- (void)requestDidSucceed:(UADownloadContent *)downloadContent;
- (void)requestDidFail:(UADownloadContent *)downloadContent;
- (void)downloadQueueProgress:(float)progress count:(int)count;
@end


@interface UADownloadManager : NSObject {
    id<UADownloadManagerDelegate> delegate;
    
    UA_ASINetworkQueue *downloadNetworkQueue;
    UA_ASINetworkQueue *networkQueue;
    UIBackgroundTaskIdentifier bgTask;
    BOOL continueDownloadsInBackground;
}

@property (assign, nonatomic) id<UADownloadManagerDelegate> delegate;

- (void)download:(UADownloadContent *)content;
- (int)downloadingContentCount;
- (NSArray *)allDownloadingContents;

- (void)cancel:(UADownloadContent *)downloadContent;
- (void)updateProgressDelegate:(UADownloadContent *)downloadContent;
- (BOOL)isDownloading:(UADownloadContent *)downloadContent;

- (void)endBackground;
@end
