// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>


#pragma mark * MSUser Public Interface


// The |MSUser| class represents an end user that can login to a Windows Azure
// Mobile Service on a client device.
@interface MSUser : NSObject <NSCopying>


#pragma mark * Public Readonly Properties


// The user id of the end user.
@property (nonatomic, copy, readonly)   NSString *userId;


#pragma mark * Public Readwrite Properties

// A Windows Azure Mobile Services authentication token for the logged in
// end user. If non-nil, the authentication token will be included in all
// requests made to the Windows Azure Mobile Service, allowing the client to
// perform all actions on the windows Azure Mobile Service that require
// authenticated-user level permissions.
@property (nonatomic, copy)         NSString *mobileServiceAuthenticationToken;


#pragma mark * Public Initializers


// Initializes an |MSUser| instance with the given user id.
-(id) initWithUserId:(NSString *)userId;

@end
