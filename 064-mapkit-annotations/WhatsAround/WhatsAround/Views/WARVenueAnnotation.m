//
//  WARVenueAnnotation.m
//  WhatsAround
//
//  Created by ben on 4/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARVenueAnnotation.h"

@interface WARVenueAnnotation ()
@property (nonatomic, strong) FSQVenue *venue;
@end

@implementation WARVenueAnnotation

- (id)initWithVenue:(FSQVenue *)venue {
    self = [super init];
    if (self) {
        self.venue = venue;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.venue.latitude floatValue], [self.venue.longitude floatValue]);
}

- (NSString *)title {
    return self.venue.name;
}

@end
