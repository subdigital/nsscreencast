/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PF_FBRequestDelegate;

enum {
    PF_kFBRequestStateReady,
    PF_kFBRequestStateLoading,
    PF_kFBRequestStateComplete,
    PF_kFBRequestStateError
};
typedef NSUInteger PF_FBRequestState;

/**
 * Do not use this interface directly, instead, use method in Facebook.h
 */
@interface PF_FBRequest : NSObject {
    id<PF_FBRequestDelegate> _delegate;
    NSString*             _url;
    NSString*             _httpMethod;
    NSMutableDictionary*  _params;
    NSURLConnection*      _connection;
    NSMutableData*        _responseText;
    PF_FBRequestState        _state;
    NSError*              _error;
    BOOL                  _sessionDidExpire;
}


@property(nonatomic,assign) id<PF_FBRequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic,copy) NSString* url;

/**
 * The API method which will be called.
 */
@property(nonatomic,copy) NSString* httpMethod;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,retain) NSMutableDictionary* params;
@property(nonatomic,retain) NSURLConnection*  connection;
@property(nonatomic,retain) NSMutableData* responseText;
@property(nonatomic,readonly) PF_FBRequestState state;
@property(nonatomic,readonly) BOOL sessionDidExpire;

/**
 * Error returned by the server in case of request's failure (or nil otherwise).
 */
@property(nonatomic,retain) NSError* error;


+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;

+ (PF_FBRequest*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<PF_FBRequestDelegate>)delegate
                        requestURL:(NSString *) url;
- (BOOL) loading;

- (void) connect;

@end

////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol PF_FBRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(PF_FBRequest *)request;

/**
 * Called when the Facebook API request has returned a response.
 * 
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(PF_FBRequest *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(PF_FBRequest *)request didLoadRawResponse:(NSData *)data;

@end

