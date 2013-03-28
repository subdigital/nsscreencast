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
#import "MSQuery.h"


#pragma  mark * MSTableURLBuilder Public Interface


// The |MSTableURLBuilder| class encapsulates the logic for building the
// appropriate URLs for table requests.
@interface MSTableURLBuilder : NSObject

#pragma  mark * Public URL Builder Methods

// Returns a URL for the table.
+(NSURL *) URLForTable:(MSTable *)table
        withParameters:(NSDictionary *)parameters
               orError:(NSError **)error;

// Returns a URL for a particular item in the table.
+(NSURL *) URLForTable:(MSTable *)table
      withItemIdString:(NSString *)itemId
        withParameters:(NSDictionary *)parameters
               orError:(NSError **)error;

// Returns a URL for querying a table with the given query.
+(NSURL *) URLForTable:(MSTable *)table
             withQuery:(NSString *)query;

// Returns a query string from an |MSQuery| instance
+(NSString *) queryStringFromQuery:(MSQuery *)query
                           orError:(NSError **)error;

@end
