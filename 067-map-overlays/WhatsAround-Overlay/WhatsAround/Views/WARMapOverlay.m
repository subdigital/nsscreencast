//
//  WARMapOverlay.m
//  WhatsAround
//
//  Created by ben on 5/4/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARMapOverlay.h"

@interface WARMapOverlay ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) MKMapRect boundingMapRect;

@end

@implementation WARMapOverlay

- (id)initWithState:(WARState *)state {
    self = [super init];
    if (self) {
        self.state = state;
        [self calculateBounds];
    }
    return self;
}

- (void)calculateBounds {
    self.boundingMapRect = MKMapRectMake(self.state.minLat,
                                         self.state.minLong,
                                         self.state.maxLat - self.state.minLat,
                                         self.state.maxLong - self.state.minLong);
    
    double centerX = self.boundingMapRect.size.width / 2 + self.state.minLong;
    double centerY = self.boundingMapRect.size.height / 2 + self.state.minLat;
    self.coordinate = CLLocationCoordinate2DMake(centerX, centerY);
}

@end
