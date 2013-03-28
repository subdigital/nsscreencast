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

#import "MSTableRequest.h"
#import "MSTableURLBuilder.h"


#pragma mark * HTTP Method String Constants


NSString *const httpGet = @"GET";
NSString *const httpPatch = @"PATCH";
NSString *const httpPost = @"POST";
NSString *const httpDelete = @"DELETE";


#pragma mark * MSTableRequest Private Interface


@interface MSTableRequest ()

// Public readonly and private readwrite properties 
@property (nonatomic, readwrite)             MSTableRequestType requestType;

// Private initalizer method
-(id) initWithURL:(NSURL *)url
            withTable:(MSTable *)table
            withSerializer:(id<MSSerializer>)serializer;

@end


#pragma mark * MSTableItemRequest Private Interface


@interface MSTableItemRequest ()

// Public readonly and private readwrite properties
@property (nonatomic, strong, readwrite)     id item;
@property (nonatomic, strong, readwrite)     id itemId;

@end


#pragma mark * MSTableDeleteRequest Private Interface


@interface MSTableDeleteRequest ()

// Public readonly and private readwrite properties
@property (nonatomic, strong, readwrite)     id item;
@property (nonatomic, strong, readwrite)     id itemId;

@end


#pragma mark * MSTableReadQueryRequest Private Interface


@interface MSTableReadQueryRequest ()

// Public readonly and private readwrite properties
@property (nonatomic, copy, readwrite)       NSString *queryString;

@end


#pragma mark * MSTableRequest Implementation


@implementation MSTableRequest

@synthesize requestType = requestType_;
@synthesize table = table_;
@synthesize serializer = serializer_;


#pragma mark * Private Initializer Method

-(id) initWithURL:(NSURL *)url
            withTable:(MSTable *)table
            withSerializer:(id<MSSerializer>)serializer
{
    self = [super initWithURL:url];
    if (self) {
        table_ = table;
        serializer_ = serializer;
    }
    
    return self;
}

#pragma mark * Public Static Constructors


+(MSTableItemRequest *) requestToInsertItem:(id)item
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion
{
    MSTableItemRequest *request = nil;
    NSError *error = nil;

    // Create the URL
    NSURL *url = [MSTableURLBuilder URLForTable:table
                                 withParameters:parameters
                                        orError:&error];
    if (!error) {
        // Create the request
        request = [[MSTableItemRequest alloc] initWithURL:url
                                                withTable:table
                                           withSerializer:serializer];
        
        // Create the body or capture the error from serialization
        NSData *data = [serializer dataFromItem:item
                                      idAllowed:NO
                                        orError:&error];
        if (!error) {
            // Set the body
            request.HTTPBody = data;
            
            // Set the additionl properties
            request.requestType = MSTableInsertRequestType;
            request.item = item;
            
            // Set the method and headers
            request.HTTPMethod = httpPost;
        }
    }
    
    // If there was an error, call the completion and make sure
    // to return nil for the request
    if (error) {
        request = nil;
        if (completion) {
            completion(nil, error);
        }
    }
    
    return request;
}

+(MSTableItemRequest *) requestToUpdateItem:(id)item
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion

{
    MSTableItemRequest *request = nil;
    NSError *error = nil;
    
    id itemId = [serializer itemIdFromItem:item orError:&error];
    if (!error) {
    
        // Ensure we can get a string from the item Id
        NSString *idString = [serializer stringFromItemId:itemId orError:&error];
        if (!error) {        

            // Create the URL
            NSURL *url = [MSTableURLBuilder URLForTable:table
                                       withItemIdString:idString
                                         withParameters:parameters
                                                orError:&error];
            if (!error) {
                
                // Create the request
                request = [[MSTableItemRequest alloc] initWithURL:url
                                                        withTable:table
                                                   withSerializer:serializer];
            
                // Create the body or capture the error from serialization
                NSData *data = [serializer dataFromItem:item
                                              idAllowed:YES
                                                orError:&error];
                if (!error) {

                    // Set the body
                    request.HTTPBody = data;
                    
                    // Set the properties
                    request.requestType = MSTableUpdateRequestType;
                    request.item = item;

                    
                    // Set the method and headers
                    request.HTTPMethod = httpPatch;
                }
            }
        }
    }
    
    // If there was an error, call the completion and make sure
    // to return nil for the request
    if (error) {
        request = nil;
        if (completion) {
            completion(nil, error);
        }
    }
    
    return request;
}

+(MSTableDeleteRequest *) requestToDeleteItem:(id)item
                                    withTable:(MSTable *)table
                               withParameters:(NSDictionary *)parameters
                               withSerializer:(id<MSSerializer>)serializer
                                   completion:(MSDeleteBlock)completion
{
    MSTableDeleteRequest *request = nil;
    NSError *error = nil;
    
    // Ensure we can get the item Id
    id itemId = [serializer itemIdFromItem:item orError:&error];
    if (!error) {

        // Get the request from the other constructor
        request = [MSTableRequest requestToDeleteItemWithId:itemId
                                                  withTable:table
                                             withParameters:parameters
                                             withSerializer:serializer
                                                    completion:completion];
        
        // Set the additional properties
        request.item = item;
    }
    
    // If there was an error, call the completion and make sure
    // to return nil for the request
    if (error) {
        request = nil;
        if (completion) {
            completion(nil, error);
        }
    }

    return request;
}

+(MSTableDeleteRequest *) requestToDeleteItemWithId:(id)itemId
                                          withTable:(MSTable *)table
                                     withParameters:(NSDictionary *)parameters
                                     withSerializer:(id<MSSerializer>)serializer
                                         completion:(MSDeleteBlock)completion
{
    MSTableDeleteRequest *request = nil;
    NSError *error = nil;
    
    // Ensure we can get the id as a string
    NSString *idString = [serializer stringFromItemId:itemId orError:&error];
    if (!error) {
    
        // Create the URL
        NSURL *url = [MSTableURLBuilder URLForTable:table
                                   withItemIdString:idString
                                     withParameters:parameters
                                            orError:&error];
        if (!error) {
            
            // Create the request
            request = [[MSTableDeleteRequest alloc] initWithURL:url
                                                      withTable:table
                                                 withSerializer:serializer];
            
            // Set the additional properties
            request.requestType = MSTableDeleteRequestType;
            request.itemId = itemId;
            
            // Set the method and headers
            request.HTTPMethod = httpDelete;
        }
    }
    
    // If there was an error, call the completion and make sure
    // to return nil for the request
    if (error) {
        request = nil;
        if (completion) {
            completion(nil, error);
        }
    }
    
    return request;
}

+(MSTableItemRequest *) requestToReadWithId:(id)itemId
                                  withTable:(MSTable *)table
                             withParameters:(NSDictionary *)parameters
                             withSerializer:(id<MSSerializer>)serializer
                                 completion:(MSItemBlock)completion
{
    MSTableItemRequest *request = nil;
    NSError *error = nil;
    
    // Ensure we can get the id as a string
    NSString *idString = [serializer stringFromItemId:itemId orError:&error];
    if (!error) {

        // Create the URL
        NSURL *url =  [MSTableURLBuilder URLForTable:table
                                    withItemIdString:idString
                                      withParameters:parameters
                                             orError:&error];
        if (!error) {
            
            // Create the request
            request = [[MSTableItemRequest alloc] initWithURL:url
                                                    withTable:table
                                               withSerializer:serializer];
            
            // Set the additional properties
            request.requestType = MSTableReadRequestType;
            request.itemId = itemId;
            
            // Set the method and headers
            request.HTTPMethod = httpGet;
        }
    }
    
    // If there was an error, call the completion and make sure
    // to return nil for the request
    if (error) {
        request = nil;
        if (completion) {
            completion(nil, error);
        }
    }
    
    return request;
}

+(MSTableReadQueryRequest *) requestToReadItemsWithQuery:(NSString *)queryString
                                      withTable:(MSTable *)table
                                 withSerializer:(id<MSSerializer>)serializer
                                     completion:(MSReadQueryBlock)completion
{
    MSTableReadQueryRequest *request = nil;
    
    // Create the URL
    NSURL *url = [MSTableURLBuilder URLForTable:table withQuery:queryString];
    
    // Create the request
    request = [[MSTableReadQueryRequest alloc] initWithURL:url
                                                 withTable:table
                                            withSerializer:serializer];
    
    // Set the additional properties
    request.requestType = MSTableReadQueryRequestType;
    request.queryString = queryString;
    
    // Set the method and headers
    request.HTTPMethod = httpGet;
    
    return request;
}

@end


#pragma mark * MSTableItemRequest Implementation


@implementation MSTableItemRequest

@synthesize itemId = itemId_;
@synthesize item = item_;

@end


#pragma mark * MSTableDeleteRequest Implementation


@implementation MSTableDeleteRequest

@synthesize itemId = itemId_;
@synthesize item = item_;

@end


#pragma mark * MSTableReadQueryRequest Implementation


@implementation MSTableReadQueryRequest

@synthesize queryString = queryString_;

@end
