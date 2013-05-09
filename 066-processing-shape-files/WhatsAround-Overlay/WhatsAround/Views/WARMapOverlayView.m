//
//  WARMapOverlayView.m
//  WhatsAround
//
//  Created by ben on 5/4/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARMapOverlayView.h"

@implementation WARMapOverlayView


- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    WARMapOverlay *overlay = self.overlay;
    CGAffineTransform scaled = CGAffineTransformMakeScale(zoomScale, zoomScale);
    
    for (WARPolygon *polygon in overlay.state.polygons) {
        CGMutablePathRef polygonPath = CGPathCreateMutable();
        BOOL firstPoint = YES;
        for (id coordValue in polygon.coordinates) {
            CLLocationCoordinate2D coord = [coordValue MKCoordinateValue];
         
            // normalize coordinate into 2d pixel space
            CGFloat x = coord.longitude  - mapRect.origin.x;
            CGFloat y = coord.latitude - mapRect.origin.y;
            
            NSLog(@"Point: (%g, %g)", x, y);
            
            if (firstPoint) {
                CGPathMoveToPoint(polygonPath, &scaled, x, y);
                firstPoint = NO;
            } else {
                CGPathAddLineToPoint(polygonPath, &scaled, x, y);
            }
        }
        
        CGContextAddPath(context, polygonPath);
        CGContextStrokePath(context);
        CGPathRelease(polygonPath);
    }
    
    CGContextRestoreGState(context);
}

@end
