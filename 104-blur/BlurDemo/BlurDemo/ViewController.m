//
//  ViewController.m
//  BlurDemo
//
//  Created by ben on 1/19/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"

#define USE_TOOLBAR_METHOD NO

const CGFloat PanelHeight = 240.0;

@interface ViewController ()

@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) UIImageView *blurImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self captureBlurImage];
}

- (void)captureBlurImage {
    UIScreen *screen = [UIScreen mainScreen];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, screen.scale);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurImage = [snapshot applyDarkEffect];
    self.blurImage = blurImage;
    
//    NSData *imageData = UIImageJPEGRepresentation(blurImage, .70);
//    NSString *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    [imageData writeToFile:[docsDir stringByAppendingPathComponent:@"test.jpg"] atomically:YES];
    
    UIGraphicsEndImageContext();
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    if (!self.panel) {
        return;
    }
    
    [self closePanel];
}

- (void)closePanel {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.panel.frame;
                         frame.origin.y += frame.size.height;
                         self.panel.frame = frame;
                         
                         CGRect blurFrame = self.blurImageView.frame;
                         blurFrame.size.height = self.view.frame.size.height - frame.origin.y;
                         self.blurImageView.frame = blurFrame;
                         
                     } completion:^(BOOL finished) {
                         [self.panel removeFromSuperview];
                         self.panel = nil;
                     }];
}

- (void)createPanel {
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PanelHeight)];
    self.panel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
#if USE_TOOLBAR_METHOD
    UIToolbar *blurToolbar = [[UIToolbar alloc] initWithFrame:self.panel.bounds];
    blurToolbar.barStyle = UIBarStyleBlackTranslucent;
    blurToolbar.translucent = YES;
    blurToolbar.alpha = 0.94;
    [self.panel addSubview:blurToolbar];
#else
    
    self.blurImageView = [[UIImageView alloc] initWithFrame:self.panel.bounds];
    self.blurImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.blurImageView.image = self.blurImage;
    self.blurImageView.contentMode = UIViewContentModeBottom;
    self.blurImageView.clipsToBounds = YES;
    [self.panel addSubview:self.blurImageView];
    
#endif
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
    [self.panel addGestureRecognizer:pan];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.panel.bounds, 10, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed neque mi, viverra sit amet ligula id, eleifend iaculis arcu. Pellentesque volutpat venenatis mauris, non tempus eros dapibus a. Duis aliquam augue quis justo lobortis, vel faucibus mauris convallis. Aenean dictum egestas ultricies. Vivamus sit amet adipiscing libero. Curabitur faucibus justo id elit dictum condimentum. Curabitur dictum bibendum sem id pharetra. Nunc eu diam eros. Donec tempus tincidunt velit ut malesuada. Nunc convallis nisl sit amet velit vestibulum, et porttitor elit euismod. Sed ut placerat dolor. Vivamus quis tellus bibendum, auctor ligula quis, bibendum nibh.";
    label.numberOfLines = 8;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:14];
    [self.panel addSubview:label];
    
    [self.view addSubview:self.panel];
}

- (void)openPanel {
    if (!self.panel) {
        [self createPanel];
    }
    
    [UIView animateWithDuration:0.3
                    delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.panel.frame;
                         frame.origin.y -= frame.size.height;
                         self.panel.frame = frame;
                         
                         CGRect blurFrame = self.blurImageView.frame;
                         blurFrame.size.height = self.view.frame.size.height - frame.origin.y;
                         self.blurImageView.frame = blurFrame;
                     } completion:^(BOOL finished) {
                     }];
}

- (CGFloat)maxPanelY {
    return self.view.frame.size.height;
}

- (CGFloat)minPanelY {
    return [self maxPanelY] - PanelHeight;
}

- (void)onDrag:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self.panel];
    
    CGRect frame = self.panel.frame;
    frame.origin.y += offset.y;
    frame.origin.y = MIN(frame.origin.y, [self maxPanelY]);
    frame.origin.y = MAX(frame.origin.y, [self minPanelY]);
    
    self.panel.frame = frame;
    
    
    CGRect blurFrame = self.blurImageView.frame;
    blurFrame.size.height = self.view.frame.size.height - frame.origin.y;
    self.blurImageView.frame = blurFrame;
    
    
    [pan setTranslation:CGPointZero inView:self.panel];
}

- (IBAction)infoTapped:(id)sender {
    if (!self.panel) {
        [self openPanel];
    }
}

@end
