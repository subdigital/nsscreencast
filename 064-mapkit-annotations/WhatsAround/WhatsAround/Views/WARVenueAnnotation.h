//
//  WARVenueAnnotation.h
//  WhatsAround
//
//  Created by ben on 4/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FSQVenue.h"

@interface WARVenueAnnotation : NSObject <MKAnnotation>

- (id)initWithVenue:(FSQVenue *)venue;

@end
