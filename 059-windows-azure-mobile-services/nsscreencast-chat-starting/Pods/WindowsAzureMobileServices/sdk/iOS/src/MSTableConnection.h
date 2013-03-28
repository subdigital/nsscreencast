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
#import "MSClientConnection.h"
#import "MSTable.h"
#import "MSTableRequest.h"


#pragma  mark * MSClient Public Interface


// The |MSTableConnection| class is a subclass of the |MSClientConnection|
// that takes |MSTableRequest| instances and the appropriate |MS*SuccessBlock|
// instances for calling back into when the response is received.
@interface MSTableConnection : MSClientConnection


#pragma mark * Public Readonly Properties


// The table associated with the connection.
@property (nonatomic, strong, readonly)     MSTable *table;


#pragma  mark * Public Static Constructor Methods


// Creates a connection for an update, insert, or readWithId request.
// NOTE: The request is not sent until |start| is called.
+(MSTableConnection *) connectionWithItemRequest:(MSTableItemRequest *)request
                                      completion:(MSItemBlock)completion;

// Creates a connection for a delete request. NOTE: The request is not sent
// until |start| is called.
+(MSTableConnection *) connectionWithDeleteRequest:(MSTableDeleteRequest *)request
                                        completion:(MSDeleteBlock)completion;

// Creates a connection for read with query request. NOTE: The request is not
// sent until |start| is called.
+(MSTableConnection *) connectionWithReadRequest:(MSTableReadQueryRequest *)request
                                      completion:(MSReadQueryBlock)completion;

@end
