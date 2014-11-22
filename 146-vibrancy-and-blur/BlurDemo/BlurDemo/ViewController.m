//
//  ViewController.m
//  BlurDemo
//
//  Created by ben on 1/19/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ViewController.h"

const CGFloat PanelHeight = 240.0;

@interface ViewController ()

@property (nonatomic, strong) UIView *panel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
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
                         
                     } completion:^(BOOL finished) {
                         [self.panel removeFromSuperview];
                         self.panel = nil;
                     }];
}

- (void)createPanel {
    CGRect panelRect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PanelHeight);
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.frame = panelRect;
    self.panel = visualEffectView;
    self.panel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDrag:)];
    [self.panel addGestureRecognizer:pan];
    
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    UIVisualEffectView *vibrancyContainer = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    vibrancyContainer.frame = CGRectInset(self.panel.bounds, 40, 20);
    
    UILabel *label = [[UILabel alloc] initWithFrame:vibrancyContainer.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed neque mi, viverra sit amet ligula id, eleifend iaculis arcu. Pellentesque volutpat venenatis mauris, non tempus eros dapibus a. Duis aliquam augue quis justo lobortis, vel faucibus mauris convallis. Aenean dictum egestas ultricies. Vivamus sit amet adipiscing libero. Curabitur faucibus justo id elit dictum condimentum. Curabitur dictum bibendum sem id pharetra. Nunc eu diam eros. Donec tempus tincidunt velit ut malesuada. Nunc convallis nisl sit amet velit vestibulum, et porttitor elit euismod. Sed ut placerat dolor. Vivamus quis tellus bibendum, auctor ligula quis, bibendum nibh.";
    label.numberOfLines = 8;
    label.font = [UIFont fontWithName:@"Avenir Next" size:14];
    [vibrancyContainer.contentView addSubview:label];
    
    [self.panel addSubview:vibrancyContainer];
    
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
    
    [pan setTranslation:CGPointZero inView:self.panel];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self closePanel];
    }
}

- (IBAction)infoTapped:(id)sender {
    if (!self.panel) {
        [self openPanel];
    }
}

@end
