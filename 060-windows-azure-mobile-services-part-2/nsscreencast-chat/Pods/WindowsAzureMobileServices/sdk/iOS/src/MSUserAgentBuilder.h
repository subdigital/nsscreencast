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


#pragma  mark * MSUserAgentBuilder Public Interface


// The |MSUserAgentBuilder| class encapsulates the logic for building the
// appropriate HTTP 'User-Agent' header value for all |MSClient| requests.
// Windows Azure Mobile Services expects the 'User-Agent' to be of the form:
//
//     ZUMO/<sdk-version> (<Device> <OS> <OS-version> <sdk-language>) <application>/<app-version>
//
@interface MSUserAgentBuilder : NSObject


#pragma  mark * Public UserAgent Method


// The HTTP 'User-Agent' value to use with all |MSClient| requests
+(NSString *) userAgent;

@end
