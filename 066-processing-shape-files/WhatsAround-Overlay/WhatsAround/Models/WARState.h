//
//  WARState.h
//  WhatsAround
//
//  Created by ben on 5/4/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shapefil.h"
#import <MapKit/MapKit.h>

@interface WARState : NSObject

@property (nonatomic, strong) NSArray *polygons;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) double minLat;
@property (nonatomic, assign) double maxLat;
@property (nonatomic, assign) double minLong;
@property (nonatomic, assign) double maxLong;


- (id)initWithShapeObject:(SHPObject *)shape;

@end

@interface WARPolygon : NSObject

@property (nonatomic, strong) NSArray *coordinates;

@end

