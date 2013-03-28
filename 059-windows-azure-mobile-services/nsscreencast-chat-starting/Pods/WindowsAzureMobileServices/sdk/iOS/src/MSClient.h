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
#import <UIKit/UIKit.h>
#import "MSError.h"
#import "MSFilter.h"
#import "MSLoginController.h"

@class MSTable;
@class MSUser;


#pragma  mark * MSClient Public Interface


// The |MSClient| class is the starting point for working with a Windows Azure
// Mobile Service on a client device. An instance of the |MSClient| class is
// created with a URL pointing to a Windows Azure Mobile Service. The |MSClient|
// allows the developer to get |MSTable| instances, which are used to work with
// the data of the Windows Azure Mobile Service, as well as login and logout an
// end user.
@interface MSClient : NSObject <NSCopying>


#pragma mark * Public Readonly Properties


// The URL of the Windows Azure Mobile Service associated with the client.
@property (nonatomic, strong, readonly)     NSURL *applicationURL;

// The application key for the Windows Azure Mobile Service associated with
// the client if one was provided in the creation of the client and nil
// otherwise. If non-nil, the application key will be included in all requests
// made to the Windows Azure Mobile Service, allowing the client to perform
// all actions on the windows Azure Mobile Service that require application-key
// level permissions.
@property (nonatomic, copy, readonly)     NSString *applicationKey;

// A collection of |MSFilter| instances to apply to use with the requests and
// responses sent and received by the client. The property is readonly and the
// array is not-mutable. To apply a filter to a client, use the |withFilter:|
// method.
@property (nonatomic, strong, readonly)         NSArray *filters;

#pragma mark * Public ReadWrite Properties


// The currently logged in user. While the |currentUser| property can be set
// directly, the |login*| and |logout| methods are more convenient and
// recommended for non-testing use.
@property (nonatomic, strong)               MSUser *currentUser;


#pragma  mark * Public Static Constructor Methods


// Creates a client with the given URL for the Windows Azure Mobile Service.
+(MSClient *) clientWithApplicationURLString:(NSString *)urlString;

// Creates a client with the given URL and application key for the Windows Azure
// Mobile Service.
+(MSClient *) clientWithApplicationURLString:(NSString *)urlString
                           withApplicationKey:(NSString *)key;

// Creates a client with the given URL for the Windows Azure Mobile Service.
+(MSClient *) clientWithApplicationURL:(NSURL *)url;

// Creates a client with the given URL and application key for the Windows Azure
// Mobile Service.
+(MSClient *) clientWithApplicationURL:(NSURL *)url
                     withApplicationKey:(NSString *)key;


#pragma  mark * Public Initializer Methods


// Intiliazes a client with the given URL for the Windows Azure Mobile Service.
-(id) initWithApplicationURL:(NSURL *)url;

// Intiliazes a client with the given URL and application key for the Windows
// Azure Mobile Service.
-(id) initWithApplicationURL:(NSURL *)url withApplicationKey:(NSString *)key;


#pragma mark * Public Filter Methods


// Creates a clone of the client with the given filter applied to the new client.
-(MSClient *) clientwithFilter:(id<MSFilter>)filter;


#pragma  mark * Public Login and Logout Methods

// Logs in the current end user with the given provider by presenting the
// MSLoginController with the given |controller|.
-(void) loginWithProvider:(NSString *)provider
             onController:(UIViewController *)controller
                 animated:(BOOL)animated
               completion:(MSClientLoginBlock)completion;

// Returns an |MSLoginController| that can be used to log in the current
// end user with the given provider.
-(MSLoginController *) loginViewControllerWithProvider:(NSString *)provider
                                completion:(MSClientLoginBlock)completion;

// Logs in the current end user with the given provider and the given token for
// the provider.
-(void) loginWithProvider:(NSString *)provider
                withToken:(NSDictionary *)token
                completion:(MSClientLoginBlock)completion;

// Logs out the current end user.
-(void) logout;


#pragma  mark * Public GetTable Methods


// Returns an |MSTable| instance for a table with the given name.
-(MSTable *) getTable:(NSString *)tableName;

@end
