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

#import "UAContentURLCache.h"

@interface UAContentURLCache()

/** Sets up a compound key for use with the content cache
 @param URL The NSURL that will be the first part of the key
 @param version The NSNumber that represents the version number of the product to be cached
 @return NSString Compound key created by concatenating the two values with a delimiter "<-version_product->"
 */
- (NSString*)compoundKeyFromURL:(NSURL*)URL andVersion:(NSNumber*)version;

/** Deconstructs a compound key for the product
 @param compoundKey NSString in the form versionNumber<delimiter>productURL
 @return NSDictionary with the values for the version number and the productURL
 @return nil If the product is not found, or the key is not parsible
 */
- (NSDictionary*)productURLAndVersionFromCompoundKey:(NSString*)compoundKey;

- (void)readFromDisk;
- (void)saveToDisk;

@end
