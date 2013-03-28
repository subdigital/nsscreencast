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
#import "MSClient.h"


#pragma mark * Block Type Definitions


// Callback for connections. If there was an error, the |error| will be non-nil.
// If there was not an error, the |response| will be non-nil, but
// the |data| may or may not be nil depending on if the response had content.
typedef void (^MSResponseBlock)(NSHTTPURLResponse *response,
                                NSData *data,
                                NSError *error);


#pragma  mark * MSClient Public Interface


// The |MSClientConnection| class sends an HTTP request asynchronously and
// returns either the response and response data or an error via block
// callbacks.
@interface MSClientConnection : NSObject


#pragma mark * Public Readonly Properties


// The client that created the connection
@property (nonatomic, strong, readonly)     MSClient *client;
@property (nonatomic, strong, readonly)     NSURLRequest *request;
@property (nonatomic, copy, readonly)       MSResponseBlock completion;


#pragma  mark * Public Initializer Methods


// Initializes an |MSClientConnection| with the given client sends the given
// request. NOTE: The request is not sent until |start| is called.
-(id) initWithRequest:(NSURLRequest *)request
           withClient:(MSClient *)client
            completion:(MSResponseBlock)completion;


#pragma mark * Public Start Methods


// Sends the request.
-(void) start;

// Sends the request without using the client's filters
-(void) startWithoutFilters;

@end
