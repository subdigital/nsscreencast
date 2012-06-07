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

/**
 * An enum representing the types of local storage available,
 * as per Apple's iOS Data Storage Guidelines.
 */
typedef enum {
    /**
     * Represents permanent data that should be backed up.
     */
    UALocalStorageTypeCritical = 0,
    /**
     * Represents semi-permanent data such as caches, that can be regenerated.
     */
    UALocalStorageTypeCached = 1,
    /**
     * Represents temporary data.
     */
    UALocalStorageTypeTemporary = 2,
    /**
     * Represents permanent data that should not be backed up.
     */
    UALocalStorageTypeOffline = 3
} UALocalStorageType;

/**
 * This class provides an abstracted interface to a local storage directory
 * that corresponds to one of the four types enumerated in Apple's iOS Data
 * Storage Guidelines. When referring to a path through an instance of this class,
 * the directory will be transparently created on disk if necessary, setting appropriate
 * file attributes, and migrating any existing content from a set of old locations.
 */
@interface UALocalStorageDirectory : NSObject {
    UALocalStorageType storageType;
    NSString *subpath;
    NSSet *oldPaths; //of NSString
}

/**
 * Convenience constructor for a UALocalStorageDirectory instance pointing to the main UA storage directory.
 * 
 * @return a UALocalStorageDirectory instance pointing to the main UA storage directory.
 */
+ (UALocalStorageDirectory *)uaDirectory;

/**
 * Convenience constructor for an arbitrary UALocalStorageDirectory.
 *
 * @param storageType A UALocalStorageType enum corresponding to the purpose and lifecycle of the directory.
 * @param nameString A subpath string to be appended to the base directory.
 * @param oldPathsSet An NSSet of directories as NSStrings to check for old content and migrate if necessary.
 *
 * @return a UALocalStorageDirectory instance.
*/
+ (UALocalStorageDirectory *)localStorageDirectoryWithType:(UALocalStorageType)storageType withSubpath:(NSString *)nameString withOldPaths:(NSSet *)oldPathsSet;

/**
 * Returns a full path string of a subdirectory to be located under the receiver's path.
 * If this subpath does not currently exist, it will be created automatically.
 *
 * @param component A subcomponent to be appended to the receiver's path
 *
 * @return A full path as an NSString.
 */
- (NSString *)subDirectoryWithPathComponent:(NSString *)component;

/**
 * The directory's storage type.
 */
@property(nonatomic, assign) UALocalStorageType storageType;
/**
 *The directory's subpath under its base location.
 */
@property(nonatomic, copy) NSString *subpath;
/**
 *The set of old directory locations to migrate existing content from.
 */
@property(nonatomic, retain) NSSet *oldPaths;
/**
 * The full path of the directory.
 * Note that this property is readonly, and the path in question is dynamically generated
 * when read.
 */
@property(nonatomic, readonly) NSString *path;

@end
