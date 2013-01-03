//
//  ViewController.m
//  PhotoTable
//
//  Created by ben on 12/31/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *imageFilenames;
@property (nonatomic, assign) NSInteger nextImageIndex;

@end

@implementation ViewController

- (UIImage *)nextImage {
    int index = self.nextImageIndex % self.imageFilenames.count;
    self.nextImageIndex++;
    return [UIImage imageNamed:self.imageFilenames[index]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageFilenames = @[ @"appriver.jpg", @"moscone.jpg", @"golden_gate.jpg" ];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onViewDoubleTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onSwipeDown:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    swipeRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)onViewDoubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchCenter = [tap locationInView:self.view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self nextImage]];
    
    CGRect imageViewFrame = CGRectMake(0, 0, 200, 200);
    imageViewFrame.origin = CGPointMake(touchCenter.x - imageViewFrame.size.width / 2.0f, touchCenter.y - imageViewFrame.size.height / 2.0f);
    imageView.frame = imageViewFrame;
    
    imageView.layer.borderWidth = 4;
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    CGAffineTransform transform = imageView.transform;
    CGPathAddRect(shadowPath, &transform, imageView.bounds);
    
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shadowPath = shadowPath;
    
    CGPathRelease(shadowPath);
    
    imageView.alpha = 0.75;
    imageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    
    CGFloat angle = DEGREES_TO_RADIANS((arc4random() % 10) - 5);
    imageView.transform = CGAffineTransformRotate(imageView.transform, angle);
    
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        imageView.alpha = 1;
        imageView.transform = CGAffineTransformIdentity;
    }];
    
    [self addGestureRecognizersToView:imageView];
}

- (void)onSwipeDown:(UISwipeGestureRecognizer *)swipe {
    [UIView animateWithDuration:0.5
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             CGPoint center = subview.center;
                             center.y += 1200;
                             subview.center = center;
                             
                             subview.alpha = 0.75;
                         }
                     } completion:^(BOOL finished) {
                         for (UIView *subview in self.view.subviews) {
                             [subview removeFromSuperview];
                         }
                     }];
}

- (void)addGestureRecognizersToView:(UIView *)view {
    view.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onPan:)];
    panRecognizer.delegate = self;
    [view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(onPinch:)];
    pinchRecognizer.delegate = self;
    [view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(onRotate:)];
    rotationRecognizer.delegate = self;
    [view addGestureRecognizer:rotationRecognizer];
}

- (void)onPan:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self.view];
    CGPoint center = pan.view.center;
    center.x += offset.x;
    center.y += offset.y;
    pan.view.center = center;
    
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = [pinch scale];
    UIView *view = pinch.view;
    view.transform = CGAffineTransformScale(view.transform, scale, scale);
    [pinch setScale:1];
}

- (void)onRotate:(UIRotationGestureRecognizer *)rotation {
    CGFloat angle = [rotation rotation];
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, angle);
    [rotation setRotation:0];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        UIView *hitTestView = [self.view hitTest:touchPoint withEvent:nil];
        if ([hitTestView isKindOfClass:[UIImageView class]]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
