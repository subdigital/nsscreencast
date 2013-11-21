//
//  FaceView.h
//  CoreImageFun
//
//  Created by ben on 11/17/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreImage;

@interface FaceView : UIView

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) CIFaceFeature *feature;

@end
