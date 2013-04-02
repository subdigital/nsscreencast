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

#import "MSNaiveISODateFormatter.h"


#pragma mark * DateTime Format

NSString *const format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";


#pragma mark * MSDateFormatter Implementation


@implementation MSNaiveISODateFormatter


static MSNaiveISODateFormatter *staticDateFormatterSingleton;


#pragma mark * Public Static Singleton Constructor


+(MSNaiveISODateFormatter *) naiveISODateFormatter
{
    if (staticDateFormatterSingleton == nil) {
        staticDateFormatterSingleton = [[MSNaiveISODateFormatter alloc] init];
    }
    
    return  staticDateFormatterSingleton;
}


#pragma mark * Public Initializer Methods


-(id) init
{
    self = [super init];
    if (self) {

        // To ensure we ignore user locale and preferences we use the
        // following locale
        NSLocale *locale = [[NSLocale alloc]
                            initWithLocaleIdentifier:@"en_US_POSIX"];
        [self setLocale:locale];
        
        // Set the date format
        [self setDateFormat:format];
        
        // Set the time zone to GMT
        [self setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    return self;
}

@end
