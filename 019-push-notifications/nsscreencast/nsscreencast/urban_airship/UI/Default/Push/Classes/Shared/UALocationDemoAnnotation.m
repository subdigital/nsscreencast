/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "UALocationDemoAnnotation.h"
#import "UAGlobal.h"

@implementation UALocationDemoAnnotation
@synthesize coordinate = coordinate_;
@synthesize title = title_;
@synthesize subtitle = subtitle_;

- (void)dealloc {
    RELEASE_SAFELY(title_);
    RELEASE_SAFELY(subtitle_);
    [super dealloc];
}

- (id)initWithLocation:(CLLocation*)location {
    self = [super init];
    if (self){
        coordinate_ = location.coordinate;
        title_ = @"Location";
        subtitle_ = [[self monthDateFromDate:location.timestamp] retain];
    }
    return self;
}

- (NSString*)monthDateFromDate:(NSDate *)date {
    NSUInteger components = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *monthDay = [[NSCalendar currentCalendar] components:components fromDate:date];
    return [NSString stringWithFormat:@"%d/%d", monthDay.month, monthDay.day];
}

+ (UALocationDemoAnnotation*)locationAnnotationFromLocation:(CLLocation*)location {
    return [[[UALocationDemoAnnotation alloc] initWithLocation:location] autorelease];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@ %f %f", title_, subtitle_, coordinate_.longitude, coordinate_.latitude];
}


@end
