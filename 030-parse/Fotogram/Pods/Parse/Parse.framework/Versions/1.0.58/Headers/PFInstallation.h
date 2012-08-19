//
//  PFInstallation.h
//  Parse
//
//  Created by Brian Jacokes on 6/4/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFObject.h"

/*!
 A Parse Framework Installation Object that is a local representation of an
 installation persisted to the Parse cloud. This class is a subclass of a
 PFObject, and retains the same functionality of a PFObject, but also extends
 it with installation-specific fields and related immutability and validity
 checks. A valid PFInstallation can only be instantiated via
 [PFInstallation currentInstallation], because the required identifier fields
 are readonly.

 PFInstallation objects which have a valid deviceToken and are saved to
 the Parse cloud can be used to target push notifications.
 */

@interface PFInstallation : PFObject {
}

/** @name Accessing the Current Installation */

/*!
 Gets the currently-running installation from disk and returns an instance of
 it. If this installation is not stored on disk, returns a PFInstallation
 with deviceType, installationId, and timeZone fields set to those of the
 current installation, and a deviceToken field set to the value stored by
 [PFPush storeDeviceToken:]. In the latter case, if this installation matches
 one in the Parse cloud, then calling save will fill in this installation's
 objectId instead of creating a new installation.
 @result Returns a PFInstallation that represents the currently-running
 installation.
 */
+ (PFInstallation *)currentInstallation;

/// The device type for the PFInstallation.
@property (nonatomic, readonly, retain) NSString *deviceType;

/// The installationId for the PFInstallation.
@property (nonatomic, readonly, retain) NSString *installationId;

/// The device token for the PFInstallation.
@property (nonatomic, readonly, retain) NSString *deviceToken;

/// The timeZone for the PFInstallation.
@property (nonatomic, readonly, retain) NSString *timeZone;

/// The channels for the PFInstallation.
@property (nonatomic, retain) NSArray *channels;

@end
