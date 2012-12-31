//
//  ViewController.m
//  PhotoTable
//
//  Created by ben on 12/31/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *imageFilenames;
@property (nonatomic, assign) NSInteger nextImageIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageFilenames = @[ @"appriver.jpg", @"moscone.jpg", @"golden_gate.jpg" ];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onViewSwipe:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    swipeRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)onViewTap:(UITapGestureRecognizer *)gesture {
    NSInteger index = self.nextImageIndex;
    self.nextImageIndex++;
    UIImage *image = [UIImage imageNamed:self.imageFilenames[index % self.imageFilenames.count]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    // where did we tap?
    CGPoint tapPoint = [gesture locationInView:self.view];
    
    // position centered around tap
    CGRect imageFrame = imageView.frame;
    CGSize size = CGSizeMake(150, 150);
    imageFrame.size = size;
    
    CGPoint origin = CGPointMake(tapPoint.x - imageFrame.size.width / 2.0f, tapPoint.y - imageFrame.size.height / 2.0f);
    imageFrame.origin = origin;
    imageView.frame = imageFrame;
    
    imageView.alpha = 0.75;
    CGFloat randomAngle = DEGREES_TO_RADIANS( (arc4random() % 10) - 5 );
    imageView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.25, 1.25), randomAngle);
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        imageView.alpha = 1.0;
        imageView.transform = CGAffineTransformIdentity;
    }];
    
    
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 3;
    
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    CGAffineTransform transform = imageView.transform;
    CGPathAddRect(shadowPath, &transform, imageView.bounds);
    imageView.layer.shadowPath = shadowPath;
    imageView.layer.shadowOffset = CGSizeMake(0, 1.0);
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    [self addGesturesToImageView:imageView];
}

- (void)onViewSwipe:(UISwipeGestureRecognizer *)swipe {
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.center = CGPointMake(subview.center.x, subview.center.x + 1000);
        }
    } completion:^(BOOL finished) {
        for (UIView *subview in self.view.subviews) {
            [subview removeFromSuperview];
        }
    }];
}

- (void)addGesturesToImageView:(UIImageView *)imageView {
    imageView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    panRecognizer.delegate = self;
    [imageView addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchGesture:)];
    panRecognizer.delegate = self;
    [imageView addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotateGesture:)];
    rotationRecognizer.delegate = self;
    [imageView addGestureRecognizer:rotationRecognizer];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint position = panRecognizer.view.center;
    position.x += translation.x;
    position.y += translation.y;
    
    panRecognizer.view.center = position;
    [panRecognizer setTranslation:CGPointZero inView:self.view];
}

- (void)onPinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
    CGFloat scale = pinchRecognizer.scale;
    pinchRecognizer.view.transform = CGAffineTransformScale(pinchRecognizer.view.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)onRotateGesture:(UIRotationGestureRecognizer *)rotationRecognizer {
    CGFloat angle = rotationRecognizer.rotation;
    rotationRecognizer.view.transform = CGAffineTransformRotate(rotationRecognizer.view.transform, angle);
    rotationRecognizer.rotation = 0;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Gesture Recognizer should begin? %@", gestureRecognizer.class);
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        NSLog(@"Swipe detected, what is the view? %@", self.view);
        CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
        UIView *gestureView = [self.view hitTest:touchLocation withEvent:nil];
        if ([gestureView isKindOfClass:[UIImageView class]])
            return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}

@end
