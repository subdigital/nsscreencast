//
//  WARMapOverlay.h
//  WhatsAround
//
//  Created by ben on 5/4/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WARState.h"

@interface WARMapOverlay : NSObject <MKOverlay>

@property (nonatomic, strong) WARState *state;

- (id)initWithState:(WARState *)state;

@end
