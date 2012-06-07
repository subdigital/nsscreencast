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

@interface UAInboxURLCache : NSURLCache {
  @private
    NSString *cacheDirectory;
    NSArray *resourceTypes;
    NSMutableDictionary *metadata;
    NSUInteger actualDiskCapactiy;
    NSOperationQueue *queue;
}

@property(nonatomic, retain) NSString *cacheDirectory;
@property(nonatomic, retain) NSArray *resourceTypes;

/**
 * The actual disk capacity of this cache.
 *
 * This method is useful because the diskCapacity getter on this class returns a highly
 * inflated value.
 *
 * @see diskCapacity
 *
 * @returns The cache's actual maximum size, in bytes
 */
 
@property(nonatomic, assign) NSUInteger actualDiskCapacity;

/**
 * Overrides [NSURLCache diskCapacity].
 *
 * This method returns a highly inflated number. UIWebView will fail to cache large items
 * if the size of the content is large in comparison to the size of the disk cache. A large
 * value (actual capacity) * 50 ensures that it will attempt to cache everything, allowing
 * this cache to make its own decisions.
 *
 * @see actualDiskCapacity
 *
 * @returns actualDiskCapacity * 50
 */
- (NSUInteger)diskCapacity;

@end
