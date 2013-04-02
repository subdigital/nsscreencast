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
#import "MSError.h"


#pragma mark * Block Type Definitions


// Callback that the filter should invoke once an HTTP response (with or
// without data) or an error has been received by the filter.
typedef void (^MSFilterResponseBlock)(NSHTTPURLResponse *response, NSData *data, NSError *error);

// Callback that the filter should invoke to allow the next filter to handle
// the given request.
typedef void (^MSFilterNextBlock)(NSURLRequest *request,
                                  MSFilterResponseBlock onResponse);


#pragma  mark * MSFilter Public Protocol


// The |MSFilter| protocol allows developers to implement a class that can
// inspect and/or replace HTTP request and HTTP response messages being sent
// and received by an |MSClient| instance.
@protocol MSFilter <NSObject>

-(void) handleRequest:(NSURLRequest *)request
               onNext:(MSFilterNextBlock)onNext
           onResponse:(MSFilterResponseBlock)onResponse;
@end
