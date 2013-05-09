//
//  WARState.m
//  WhatsAround
//
//  Created by ben on 5/4/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARState.h"

@implementation WARPolygon

@end

@implementation WARState

- (id)initWithShapeObject:(SHPObject *)shape {
    self = [super init];
    if (self) {
        int numParts = shape->nParts;
        int totalVertexCount = shape->nVertices;
        
        self.minLat = shape->dfYMin;
        self.maxLat = shape->dfYMax;
        self.minLong = shape->dfXMin;
        self.maxLong = shape->dfXMax;
        
        self.color = [[UIColor redColor] colorWithAlphaComponent:0.7];
        
        NSMutableArray *polygons = [NSMutableArray arrayWithCapacity:numParts];
        for (int n=0; n<numParts; n++) {
            int startVertex = shape->panPartStart[n];
            int partVertexCount = (n == numParts - 1) ? totalVertexCount - startVertex : shape->panPartStart[n+1] - startVertex;
            WARPolygon *polygon = [[WARPolygon alloc] init];
            NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:partVertexCount];
            int endIndex = startVertex + partVertexCount;
            for (int pv=startVertex; pv<endIndex; pv++) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(shape->padfY[pv],
                                                                          shape->padfX[pv]);
                
                [coordinates addObject:[NSValue valueWithMKCoordinate:coord]];
                polygon.coordinates = coordinates;
            }
            [polygons addObject:polygon];
            self.polygons = polygons;
        }
    }
    return self;
}

@end
