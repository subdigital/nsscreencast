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

#import "MSTableConnection.h"
#import "MSSerializer.h"


#pragma mark * MSTableConnection Private Interface


@interface MSTableConnection ()

// Private properties
@property (nonatomic, strong, readwrite)        id<MSSerializer> serializer;

@end


#pragma mark * MSTableConnection Implementation


@implementation MSTableConnection

@synthesize table = table_;
@synthesize serializer = serializer_;


#pragma mark * Public Static Constructors


+(MSTableConnection *) connectionWithItemRequest:(MSTableItemRequest *)request
                                      completion:(MSItemBlock)completion
{
    // We'll use the conection in the response block below but won't set
    // it until the init at the end, so we need to use __block
    __block MSTableConnection *connection = nil;
    
    // Create an HTTP response block that will invoke the MSItemBlock
    MSResponseBlock responseCompletion = nil;
    
    if (completion) {
    
        responseCompletion = 
        ^(NSHTTPURLResponse *response, NSData *data, NSError *error)
        {
            id item = nil;
            
            if (!error) {
                
                [connection isSuccessfulResponse:response
                                        withData:data
                                         orError:&error];
                if (!error)
                {
                    item = [connection itemFromData:data
                                       withResponse:response
                                            orError:&error];
                }
            }
            
            [connection addRequestAndResponse:response toError:&error];
            completion(item, error);
            connection = nil;
        };
    }
    
    // Now create the connection with the MSResponseBlock
    connection = [[MSTableConnection alloc] initWithTableRequest:request
                                                      completion:responseCompletion];
    return connection;
}

+(MSTableConnection *) connectionWithDeleteRequest:(MSTableDeleteRequest *)request
                                        completion:(MSDeleteBlock)completion
{
    // We'll use the conection in the response block below but won't set
    // it until the init at the end, so we need to use __block
    __block MSTableConnection *connection = nil;
    
    // Create an HTTP response block that will invoke the MSDeleteBlock
    MSResponseBlock responseCompletion = nil;
    
    if (completion) {
    
        responseCompletion =
        ^(NSHTTPURLResponse *response, NSData *data, NSError *error)
        {
            
            if (!error) {
                [connection isSuccessfulResponse:response
                                        withData:data
                                         orError:&error];
            }
            
            if (error) {
                [connection addRequestAndResponse:response toError:&error];
                completion(nil, error);
            }
            else {
                completion(request.itemId, nil);
            }
            connection = nil;
        };
    }
    
    // Now create the connection with the MSResponseBlock
    connection = [[MSTableConnection alloc] initWithTableRequest:request
                                                      completion:responseCompletion];
    return connection;

}
                                      
+(MSTableConnection *) connectionWithReadRequest:(MSTableReadQueryRequest *)request
                                      completion:(MSReadQueryBlock)completion
{
    // We'll use the conection in the response block below but won't set
    // it until the init at the end, so we need to use __block
    __block MSTableConnection *connection = nil;
    
    // Create an HTTP response block that will invoke the MSReadQueryBlock
    MSResponseBlock responseCompletion = nil;
    
    if (completion) {
    
        responseCompletion =
        ^(NSHTTPURLResponse *response, NSData *data, NSError *error)
        {
            NSArray *items = nil;
            NSInteger totalCount = -1;
            
            if (!error) {
                
                [connection isSuccessfulResponse:response
                                        withData:data
                                         orError:&error];
                if (!error) {
                    totalCount = [connection items:&items
                                          fromData:data
                                      withResponse:response
                                           orError:&error];
                }
            }
            
            [connection addRequestAndResponse:response toError:&error];
            completion(items, totalCount, error);
            connection = nil;
        };
    }
    
    // Now create the connection with the MSSuccessBlock
    connection = [[MSTableConnection alloc] initWithTableRequest:request
                                                      completion:responseCompletion];
    return connection;
}


# pragma mark * Private Init Methods


-(id) initWithTableRequest:(MSTableRequest *)request
                 completion:(MSResponseBlock)completion{
    self = [super initWithRequest:request
                       withClient:request.table.client
                        completion:completion];
    
    if (self) {
        table_ = request.table;
        serializer_ = request.serializer;
    }
    
    return self;
}


# pragma mark * Private Methods


-(BOOL) isSuccessfulResponse:(NSHTTPURLResponse *)response
                    withData:(NSData *)data
                     orError:(NSError **)error
{
    // Success is determined just by the HTTP status code
    BOOL isSuccessful = response.statusCode < 400;
    
    if (!isSuccessful && self.completion && error) {
        
        // Read the error message from the response body
        *error =[self.serializer errorFromData:data];
        [self addRequestAndResponse:response toError:error];
    }
    
    return isSuccessful;
}

-(id) itemFromData:(NSData *)data
      withResponse:(NSHTTPURLResponse *)response
           orError:(NSError **)error
{
    // Try to deserialize the data
    id item = [self.serializer itemFromData:data
                           withOriginalItem:nil
                                    orError:error];
    
    // If there was an error, add the request and response
    if (error && *error) {
        [self addRequestAndResponse:response toError:error];
    }
    
    return item;
}

-(NSInteger) items:(NSArray **)items
                fromData:(NSData *)data
                withResponse:(NSHTTPURLResponse *)response
                orError:(NSError **)error
{
    // Try to deserialize the data
    NSInteger totalCount = [self.serializer totalCountAndItems:items
                                                      fromData:data
                                                       orError:error];
    
    // If there was an error, add the request and response
    if (error && *error) {
        [self addRequestAndResponse:response toError:error];
    }
    
    return totalCount;
}

-(BOOL) addRequestAndResponse:(NSHTTPURLResponse *)response
                toError:(NSError **)error
{
    BOOL isSuccessful = YES;
    
    if (error && *error) {        
        // Create a new error with request and the response in the userInfo...
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        [userInfo setObject:self.request forKey:MSErrorRequestKey];
        
        if (response) {
            [userInfo setObject:response forKey:MSErrorResponseKey];
        }
        
        *error = [NSError errorWithDomain:(*error).domain
                                    code:(*error).code
                                userInfo:userInfo];
        isSuccessful = NO;
    }
    
    return isSuccessful;
}

@end
