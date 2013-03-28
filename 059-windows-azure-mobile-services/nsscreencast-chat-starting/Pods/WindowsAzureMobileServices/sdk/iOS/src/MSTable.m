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

#import "MSTable.h"
#import "MSQuery.h"
#import "MSJSONSerializer.h"
#import "MSTableRequest.h"
#import "MSTableConnection.h"


#pragma mark * MSTable Private Interface


@interface MSTable ()

// Private properties
@property (nonatomic, strong, readonly)         id<MSSerializer> serializer;

@end


#pragma mark * MSTable Implementation


@implementation MSTable

@synthesize client = client_;
@synthesize name = name_;
@synthesize serializer = serializer_;


#pragma mark * Public Initializer Methods


-(id) initWithName:(NSString *)tableName andClient:(MSClient *)client;
{    
    self = [super init];
    if (self)
    {
        client_ = client;
        name_ = tableName;
    }
    return self;
}


#pragma mark * Public Insert, Update, Delete Methods


-(void) insert:(NSDictionary *)item completion:(MSItemBlock)completion
{
    [self insert:item parameters:nil completion:completion];
}

-(void) insert:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSItemBlock)completion
{
    // Create the request
    MSTableItemRequest *request = [MSTableRequest
                                   requestToInsertItem:item
                                   withTable:self
                                   withParameters:parameters
                                   withSerializer:self.serializer
                                   completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection =
            [MSTableConnection connectionWithItemRequest:request
                                              completion:completion];
        [connection start];
    }
}

-(void) update:(NSDictionary *)item completion:(MSItemBlock)completion
{
    [self update:item parameters:nil completion:completion];
}

-(void) update:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSItemBlock)completion
{
    // Create the request
    MSTableItemRequest *request = [MSTableRequest
                                   requestToUpdateItem:item
                                   withTable:self
                                   withParameters:parameters
                                   withSerializer:self.serializer
                                   completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection =
            [MSTableConnection connectionWithItemRequest:request
                                              completion:completion];
        [connection start];
    }
}

-(void) delete:(NSDictionary *)item completion:(MSDeleteBlock)completion
{
    [self delete:item parameters:nil completion:completion];
}

-(void) delete:(NSDictionary *)item
    parameters:(NSDictionary *)parameters
    completion:(MSDeleteBlock)completion
{
    // Create the request
    MSTableDeleteRequest *request = [MSTableRequest
                                     requestToDeleteItem:item
                                     withTable:self
                                     withParameters:parameters
                                     withSerializer:self.serializer
                                     completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection =
            [MSTableConnection connectionWithDeleteRequest:request
                                                completion:completion];
        [connection start];
    }
}

-(void) deleteWithId:(NSNumber *)itemId completion:(MSDeleteBlock)completion
{
    [self deleteWithId:itemId parameters:nil completion:completion];
}

-(void) deleteWithId:(NSNumber *)itemId
          parameters:(NSDictionary *)parameters
          completion:(MSDeleteBlock)completion
{
    // Create the request
    MSTableDeleteRequest *request = [MSTableRequest
                                     requestToDeleteItemWithId:itemId
                                     withTable:self
                                     withParameters:parameters
                                     withSerializer:self.serializer
                                     completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection = 
            [MSTableConnection connectionWithDeleteRequest:request
                                                completion:completion];
        [connection start];
    }
}


#pragma mark * Public Read Methods


-(void) readWithId:(NSNumber *)itemId completion:(MSItemBlock)completion
{
    [self readWithId:itemId parameters:nil completion:completion];
}

-(void) readWithId:(NSNumber *)itemId
        parameters:(NSDictionary *)parameters
        completion:(MSItemBlock)completion
{
    // Create the request
    MSTableItemRequest *request = [MSTableRequest
                                   requestToReadWithId:itemId
                                   withTable:self
                                   withParameters:parameters
                                   withSerializer:self.serializer
                                   completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection =
            [MSTableConnection connectionWithItemRequest:request
                                              completion:completion];
        [connection start];
    }
}

-(void) readWithQueryString:(NSString *)queryString
                 completion:(MSReadQueryBlock)completion
{
    // Create the request
    MSTableReadQueryRequest *request = [MSTableRequest
                                        requestToReadItemsWithQuery:queryString
                                        withTable:self
                                        withSerializer:self.serializer
                                        completion:completion];
    // Send the request
    if (request) {
        MSTableConnection *connection =
            [MSTableConnection connectionWithReadRequest:request
                                              completion:completion];
        [connection start];
    }
}

-(void) readWithCompletion:(MSReadQueryBlock)completion
{
    // Read without a query string
    [self readWithQueryString:nil completion:completion];
}

-(void) readWhere:(NSPredicate *) predicate
            completion:(MSReadQueryBlock)completion
{
    // Create the query from the predicate
    MSQuery *query = [self queryWhere:predicate];
    
    // Call read on the query
    [query readWithCompletion:completion];
}


#pragma mark * Public Query Methods


-(MSQuery *) query
{
    return [[MSQuery alloc] initWithTable:self];
}

-(MSQuery *) queryWhere:(NSPredicate *)predicate
{
    return [[MSQuery alloc] initWithTable:self withPredicate:predicate];
}


#pragma mark * Private Methods


-(id<MSSerializer>) serializer
{
    // Just use a hard coded reference to MSJSONSerializer
    return [MSJSONSerializer JSONSerializer];
}

@end
