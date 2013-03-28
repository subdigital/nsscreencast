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

#import "MSClientConnection.h"
#import "MSUserAgentBuilder.h"
#import "MSFilter.h"
#import "MSUser.h"


#pragma mark * HTTP Header String Constants


NSString *const xApplicationHeader = @"X-ZUMO-APPLICATION";
NSString *const contentTypeHeader = @"Content-Type";
NSString *const userAgentHeader = @"User-Agent";
NSString *const jsonContentType = @"application/json";
NSString *const xZumoAuth = @"X-ZUMO-AUTH";



#pragma mark * MSConnectionDelegate Private Interface


// The |MSConnectionDelegate| is a private class that implements the
// |NSURLConnectionDataDelegate| and surfaces success and error blocks. It
// is used only by the |MSClientConnection|.
@interface MSConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong)               MSClient *client;
@property (nonatomic, strong)               NSData *data;
@property (nonatomic, strong)               NSHTTPURLResponse *response;
@property (nonatomic, copy)                 MSResponseBlock completion;

-(id) initWithClient:(MSClient *)client
          completion:(MSResponseBlock)completion;

@end


#pragma mark * MSClientConnection Implementation


@implementation MSClientConnection

@synthesize client = client_;
@synthesize request = request_;
@synthesize completion = completion_;


# pragma mark * Public Initializer Methods


-(id) initWithRequest:(NSURLRequest *)request
           withClient:(MSClient *)client
            completion:(MSResponseBlock)completion
{
    self = [super init];
    if (self) {
        client_ = client;
        request_ = [MSClientConnection configureHeadersOnRequest:request
                                                      withClient:client];
        completion_ = [completion copy];
    }
    
    return self;
}


#pragma mark * Public Start Methods


-(void) start
{
    [MSClientConnection invokeNextFilter:self.client.filters
                              withClient:self.client
                             withRequest:self.request
                              completion:self.completion];
}

-(void) startWithoutFilters
{
    [MSClientConnection invokeNextFilter:nil
                              withClient:self.client
                             withRequest:self.request
                              completion:self.completion];
}


# pragma mark * Private Static Methods


+(void) invokeNextFilter:(NSArray *)filters
              withClient:(MSClient *)client
             withRequest:(NSURLRequest *)request
               completion:(MSFilterResponseBlock)completion
{
    if (!filters || filters.count == 0) {
        
        // No filters to invoke so use |NSURLConnection | to actually
        // send the request.
        MSConnectionDelegate *delegate = [[MSConnectionDelegate alloc]
                                          initWithClient:client
                                              completion:completion];
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    }
    else {
        
        // Since we have at least one more filter, construct the nextBlock
        // for it and then invoke the filter
        id<MSFilter> nextFilter = [filters objectAtIndex:0];
        NSArray *nextFilters = [filters subarrayWithRange:
                                NSMakeRange(1, filters.count - 1)];
    
        MSFilterNextBlock onNext =
        [^(NSURLRequest *onNextRequest,
           MSFilterResponseBlock onNextResponse)
        {
            [MSClientConnection invokeNextFilter:nextFilters
                                      withClient:client
                                     withRequest:onNextRequest
                                      completion:onNextResponse];                                    
        } copy];
        
        [nextFilter handleRequest:request
                           onNext:onNext
                       onResponse:completion];
    }
}

+(NSURLRequest *) configureHeadersOnRequest:(NSURLRequest *)request
                                 withClient:(MSClient *)client
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *requestHost = request.URL.host;
    NSString *applicationHost = client.applicationURL.host;
    if ([applicationHost isEqualToString:requestHost])
    {
        // Add the authentication header if the user is logged in
        if (client.currentUser &&
            client.currentUser.mobileServiceAuthenticationToken) {
            [mutableRequest
             setValue:client.currentUser.mobileServiceAuthenticationToken
             forHTTPHeaderField:xZumoAuth];
        }
        
        // Set the User Agent header
        NSString *userAgentValue = [MSUserAgentBuilder userAgent];
        [mutableRequest setValue:userAgentValue
              forHTTPHeaderField:userAgentHeader];
        
        // Set the special Application key header
        NSString *appKey = client.applicationKey;
        if (appKey != nil) {
            [mutableRequest setValue:appKey
                  forHTTPHeaderField:xApplicationHeader];
        }

        // Set the content type header
        [mutableRequest setValue:jsonContentType
              forHTTPHeaderField:contentTypeHeader];
    }
    
    return mutableRequest;
}


@end


#pragma mark * MSConnectionDelegate Private Implementation


@implementation MSConnectionDelegate

@synthesize client = client_;
@synthesize completion = completion_;
@synthesize data = data_;
@synthesize response = response_;


# pragma mark * Public Initializer Methods


-(id) initWithClient:(MSClient *)client
          completion:(MSResponseBlock)completion
{
    self = [super init];
    if (self) {
        client_ = client;
        completion_ = [completion copy];
    }
    
    return self;
}


# pragma mark * NSURLConnectionDelegate Methods


-(void) connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if (self.completion) {
        self.completion(nil, nil, error);
        [self cleanup];
    }
}


# pragma mark * NSURLConnectionDataDelegate Methods


-(void) connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    // We should only be making HTTP requests
    self.response = (NSHTTPURLResponse *)response;
}

-(void)connection: (NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    // If we haven't received any data before, just take this data instance
    if (!self.data) {
        self.data = data;
    }
    else {
        
        // Otherwise, append this data to what we have
        NSMutableData *newData = [NSMutableData dataWithData:self.data];
        [newData appendData:data];
        self.data = newData;
    }
}

-(NSCachedURLResponse *) connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    // We don't want to cache anything
    return nil;
}

-(NSURLRequest *) connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response
{
    NSURLRequest *newRequest = nil;
    
    // Only follow redirects to the Windows Azure Mobile Service and not
    // to other hosts
    NSString *requestHost = request.URL.host;
    NSString *applicationHost = self.client.applicationURL.host;
    if ([applicationHost isEqualToString:requestHost])
    {
        newRequest = request;
    }
    
    return newRequest;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completion) {
        self.completion(self.response, self.data, nil);
        [self cleanup];
    }
}

-(void) cleanup
{
    self.client = nil;
    self.data = nil;
    self.response = nil;
    self.completion = nil;
}

@end

