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
#import "UA_ASIProgressDelegate.h"

/**
 * This class represents subscription content available for download.
 */
@interface UASubscriptionContent : UAObservable <UA_ASIProgressDelegate> {
  @private
    NSString *contentName;
    NSString *contentKey;
    NSString *subscriptionKey;
	NSString *productIdentifier;
    NSURL *iconURL;
    NSURL *previewURL;
    NSURL *downloadURL;
    int revision;
    int fileSize;
    NSString *description;
    NSDate *publishDate;

    BOOL downloaded;
    float progress;
}

/**
 * The content name.
 */
@property (nonatomic, retain) NSString *contentName;
/**
 * The content key.
 */
@property (nonatomic, retain) NSString *contentKey;
/**
 * The associated subscription key.
 */
@property (nonatomic, retain) NSString *subscriptionKey;
/**
 * The associated product identifier, if present.
 */
@property (nonatomic, retain) NSString *productIdentifier;
/**
 * The URL for the content's icon.
 */
@property (nonatomic, retain) NSURL *iconURL;
/**
 * The URL for the content's preview image.
 */
@property (nonatomic, retain) NSURL *previewURL;
/**
 * The content's download URL.
 */
@property (nonatomic, retain) NSURL *downloadURL;
/**
 * The revision number.
 */
@property (nonatomic, assign) int revision;
/**
 * The file size in bytes.
 */
@property (nonatomic, assign) int fileSize;
/**
 * The content's description.
 */
@property (nonatomic, retain) NSString *description;

/**
 * The time and date the content was published.
 *
 * Note that the publish date may be outside of the purchased
 * subscription range if this is default content.
 */
@property (nonatomic, retain) NSDate *publishDate;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) BOOL downloaded;
@property (nonatomic, readonly, assign) BOOL downloading;

- (id)initWithDict:(NSDictionary *)dict;

@end
