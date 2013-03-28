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
#import "MSUser.h"


#pragma mark * MSLoginSerializer Public Interface


// The |MSLoginSerializer| is used for serializing authentication tokens and
// deserializing |MSUser| instances for login sceanarios.
@interface MSLoginSerializer : NSObject


#pragma mark * Static Singleton Constructor


// A singleton instance of the MSLoginSerializer.
+(MSLoginSerializer *) loginSerializer;


#pragma mark * Serialization Methods


// Called to serialize an authentication token. May return nil if there was an
// error, in which case |error| will be set to a non-nil value.
-(NSData *) dataFromToken:(id)token orError:(NSError **)error;


#pragma mark * Deserialization Methods


// Called to deserialize an |MSUser| instance. May return nil if there was an
// error, in which case |error| will be set to a non-nil value.
-(MSUser *) userFromData:(NSData *)data orError:(NSError **)error;

@end
