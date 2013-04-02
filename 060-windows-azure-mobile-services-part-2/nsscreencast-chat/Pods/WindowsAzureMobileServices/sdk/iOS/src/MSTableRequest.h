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
#import "MSTable.h"
#import "MSSerializer.h"

@class MSTableItemRequest;
@class MSTableDeleteRequest;
@class MSTableReadQueryRequest;


#pragma mark * Public MSTableRequestType Enum Type

// Indicates the type of table request
typedef enum MSTableRequestTypeEnum {
    MSTableInsertRequestType = 0,
    MSTableUpdateRequestType,
    MSTableDeleteRequestType,
    MSTableReadRequestType,
    MSTableReadQueryRequestType
    
} MSTableRequestType;


#pragma mark * MSTableRequest Public Interface


// The |MSTableRequest| class represents an HTTP request for a particular table
// operation. The static constructors of the |MSTableRequest| only returns
// instances of one of three subclasses: |MSTableItemRequest|,
// |MSTableDeleteRequest| and |MSTableReadQueryRequest|. These types correspond
// to the associated |MS*SuccessBlock| types that should be used with the
// request's respective response.
@interface MSTableRequest : NSMutableURLRequest


#pragma mark * Public Readonly Properties


// The type of the request--insert, update, delete, etc.
@property (nonatomic, readonly)             MSTableRequestType requestType;

// The table for which this request was created.
@property (nonatomic, strong, readonly)     MSTable *table;

// The user-defined parameters to be included in the request query string.
@property (nonatomic, strong, readonly)     NSDictionary *parameters;

// The serializer used to serialize the data for the request and/or deserialize
// the data in the respective response.
@property (nonatomic, strong, readonly)     id<MSSerializer> serializer;


#pragma  mark * Public Static Constructor Methods


// Creates a request to insert the item into the given table.
+(MSTableItemRequest *) requestToInsertItem:(id)item
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion;

// Creates a request to update the item in the given table.
+(MSTableItemRequest *) requestToUpdateItem:(id)item
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion;

// Creates a request to delete the item from the given table.
+(MSTableDeleteRequest *) requestToDeleteItem:(id)item
                                    withTable:(MSTable *)table
                               withParameters:(NSDictionary *)parameters
                               withSerializer:(id<MSSerializer>)serializer
                                   completion:(MSDeleteBlock)completion;

// Creates a request to delete the item with the given id from the given table.
+(MSTableDeleteRequest *) requestToDeleteItemWithId:(id)itemId
                                          withTable:(MSTable *)table
                                     withParameters:(NSDictionary *)parameters
                                     withSerializer:(id<MSSerializer>)serializer
                                         completion:(MSDeleteBlock)completion;

// Creates a request to read the item with the given ide from the given table.
+(MSTableItemRequest *) requestToReadWithId:(id)itemId
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion;

// Creates a request to the read the given table with the given query.
+(MSTableReadQueryRequest *) requestToReadItemsWithQuery:(NSString *)queryString
                                               withTable:(MSTable *)table
                                          withSerializer:(id<MSSerializer>)serializer
                                              completion:(MSReadQueryBlock)completion;

@end


#pragma mark * MSTableItemRequest Public Interface


// The |MSTableItemRequest| class represents a request to insert, update or
// read a single item from a table and should result in a response that includes
// that item.
@interface MSTableItemRequest : MSTableRequest


#pragma mark * Public Readonly Properties

// The item that is to be inserted or updated in the table. Will be nil if
// the |readWithId| table operation was invoked.
@property (nonatomic, strong, readonly)     id item;

// The id of the item to be updated or read from the table. Will be nil if the
// table operation is an insert.
@property (nonatomic, strong, readonly)     id itemId;

@end


#pragma mark * MSTableDeleteRequest Public Interface

// The |MSTableDeleteRequest| class represents a request to delete an item
// from a table.
@interface MSTableDeleteRequest : MSTableRequest


#pragma mark * Public Readonly Properties


// The item that is to be deleted from the table. May be nil if the
// |deleteWithId| table operation was invoked.
@property (nonatomic, strong, readonly)     id item;

// The id of the item to be deleted from the table.
@property (nonatomic, strong, readonly)     id itemId;

@end


#pragma mark * MSTableReadQueryRequest Public Interface

// The |MSTableReadQueryRequest| class represents a request to read a table
// with a particular query.
@interface MSTableReadQueryRequest : MSTableRequest


#pragma mark * Public Readonly Properties

// The query string associated with the read with query request.
@property (nonatomic, copy, readonly)       NSString *queryString;

@end
