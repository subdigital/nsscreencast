//
//  PolygonView.h
//  DrawingPolygons
//
//  Created by Ben Scheirman on 9/9/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolygonView : UIView

@property (nonatomic, assign) NSUInteger numberOfSides;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;

@end
