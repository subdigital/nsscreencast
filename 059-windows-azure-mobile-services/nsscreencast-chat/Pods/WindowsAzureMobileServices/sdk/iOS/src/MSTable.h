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

@class MSQuery;


#pragma mark * Block Type Definitions


// Callback for updates, inserts or readWithId requests. If there was an
// error, the |error| will be non-nil.
typedef void (^MSItemBlock)(NSDictionary *item, NSError *error);

// Callback for deletes. If there was an error, the |error| will be non-nil.
typedef void (^MSDeleteBlock)(NSNumber *itemId, NSError *error);

// Callback for reads. If there was an error, the |error| will be non-nil. If
// there was not an error, then the |items| array will always be non-nil
// but may be empty if the query returned no results. If the query included a
// request for the total count of items on the server (not just those returned
// in |items| array), the |totalCount| will have this value; otherwise
// |totalCount| will be -1.
typedef void (^MSReadQueryBlock)(NSArray *items,
                                 NSInteger totalCount,
                                 NSError *error);


#pragma mark * MSTable Public Interface


// The |MSTable| class represents a table of a Windows Azure Mobile Service.
// Items can be inserted, updated, deleted and read from the table. The table
// can also be queried to retrieve an array of items that meet the given query
// conditions. All table operations result in a request to the Windows Azure
// Mobile Service to perform the given operation.
@interface MSTable : NSObject


#pragma mark * Public Readonly Properties


// The name of this table.
@property (nonatomic, copy, readonly)           NSString *name;

// The client associated with this table.
@property (nonatomic, strong, readonly)         MSClient *client;


#pragma mark * Public Initializers


// Initializes an |MSTable| instance with the given name and client.
-(id) initWithName:(NSString *)tableName andClient:(MSClient *)client;


#pragma mark * Public Insert, Update and Delete Methods


// Sends a request to the Windows Azure Mobile Service to insert the given
// item into the table. The item must not have an id.
-(void) insert:(NSDictionary *)item completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to insert the given
// item into the table. Addtional user-defined parameters are sent in the
// request query string. The item must not have an id.
-(void) insert:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to update the given
// item in the table. The item must have an id.
-(void) update:(NSDictionary *)item completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to update the given
// item in the table. Addtional user-defined parameters are sent in the
// request query string. The item must have an id.
-(void) update:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to delete the given
// item from the table. The item must have an id.
-(void) delete:(NSDictionary *)item completion:(MSDeleteBlock)completion;

// Sends a request to the Windows Azure Mobile Service to delete the given
// item from the table. Addtional user-defined parameters are sent in the
// request query string. The item must have an id.
-(void) delete:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSDeleteBlock)completion;

// Sends a request to the Windows Azure Mobile Service to delete the item
// with the given id in from table.
-(void) deleteWithId:(NSNumber *)itemId completion:(MSDeleteBlock)completion;

// Sends a request to the Windows Azure Mobile Service to delete the item
// with the given id in from table. Addtional user-defined parameters are
// sent in the request query string.
-(void) deleteWithId:(NSNumber *)itemId
          parameters:(NSDictionary *)parameters
          completion:(MSDeleteBlock)completion;


#pragma mark * Public Read Methods


// Sends a request to the Windows Azure Mobile Service to return the item
// with the given id from the table.
-(void) readWithId:(NSNumber *)itemId completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to return the item
// with the given id from the table. Addtional user-defined parameters are
// sent in the request query string.
-(void) readWithId:(NSNumber *)itemId
        parameters:(NSDictionary *)parameters
        completion:(MSItemBlock)completion;

// Sends a request to the Windows Azure Mobile Service to return all items
// fromm the table that meet the conditions of the given query.
-(void) readWithQueryString:(NSString *)queryString
                 completion:(MSReadQueryBlock)completion;

// Sends a request to the Windows Azure Mobile Service to return all items
// from the table. The Windows Azure Mobile Service will apply a default
// limit to the number of items returned.
-(void) readWithCompletion:(MSReadQueryBlock)completion;

// Sends a request to the Windows Azure Mobile Service to return all items
// from the table that meet the conditions of the given predicate.
-(void) readWhere:(NSPredicate *) predicate
       completion:(MSReadQueryBlock)completion;


#pragma mark * Public Query Constructor Methods


// Returns an |MSQuery| instance associated with the table that can be
// configured and then executed to retrieve items from the table. An |MSQuery|
// instance provides more flexibilty when querying a table than the table
// |read*| methods.
-(MSQuery *) query;

// Returns an |MSQuery| instance associated with the table that uses
// the given predicate. An |MSQuery| instance provides more flexibilty when
// querying a table than the table |read*| methods.
-(MSQuery *) queryWhere:(NSPredicate *)predicate;


@end
