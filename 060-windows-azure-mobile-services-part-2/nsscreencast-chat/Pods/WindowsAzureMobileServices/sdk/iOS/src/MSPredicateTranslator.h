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


#pragma mark * MSPredicateTranslator Public Interface


// The |MSPredicateTranslator| traverses the abstract syntax tree of an
// |NSPredicate| instance and builds the filter portion of a query string.
@interface MSPredicateTranslator : NSObject

// Returns the filter portion of a query string translated from the
// given |NSPRedicate|. Will return a nil value and a non-nil error if the
// predicate is not supported.
+(NSString *) queryFilterFromPredicate:(NSPredicate *)predicate
                               orError:(NSError **)error;

@end
