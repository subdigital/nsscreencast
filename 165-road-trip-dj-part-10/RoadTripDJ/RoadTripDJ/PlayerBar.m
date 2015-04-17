//
//  PlayerBar.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 2/15/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "PlayerBar.h"

@implementation PlayerBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializePlayerBar];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializePlayerBar];
    }
    return self;
}

- (void)initializePlayerBar {
    self.enabled = false;
    self.spacing = 30;
    [self setupToolbar];
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    for (UIBarButtonItem *item in self.items) {
        item.enabled = enabled;
    }
}

- (void)prepareForInterfaceBuilder {
    UIView *prev = [[self skipBackButton] customView];
    UIView *play = [[self playButton] customView];
    UIView *next = [[self skipForwardButton] customView];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat buttonWidth = prev.frame.size.width;
    CGFloat buttonHeight = prev.frame.size.height;
    
    CGFloat y = (h - buttonHeight) / 2.0;
    CGFloat x = (w - (3 * buttonWidth) - (2 * self.spacing)) / 2.0f;
    
    NSArray *views = @[ prev, play, next];
    for (UIView *view in views) {
        CGRect rect = CGRectMake(x, y, buttonWidth, buttonHeight);
        view.frame = rect;
        [self addSubview:view];
        x += buttonWidth + self.spacing;
    }
}

- (void)setupToolbar {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    [fixedSpace setWidth:self.spacing];
    
    UIBarButtonItem *prevButton = [self skipBackButton];
    UIBarButtonItem *playButton = [self playButton];
    UIBarButtonItem *nextButton = [self skipForwardButton];
    
    self.items = @[
                   flexibleSpace,
                   prevButton,
                   fixedSpace,
                   playButton,
                   fixedSpace,
                   nextButton,
                   flexibleSpace
                   ];
    
    for (UIBarButtonItem *item in self.items) {
        item.enabled = self.enabled;
    }
}

- (UIBarButtonItem *)buttonWithImage:(NSString *)imageName
                       selectedImage:(NSString *)selectedImageName
                              target:(id)target
                              action:(SEL)action {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:bundle
           compatibleWithTraitCollection:self.traitCollection];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName
                                        inBundle:bundle
                   compatibleWithTraitCollection:self.traitCollection];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                      forState:UIControlStateNormal];
    [button setImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                      forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, image.size.width * 4, image.size.height * 2);
    button.imageEdgeInsets = UIEdgeInsetsMake(-20, -40, -20, -40);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)skipBackButton {
    return [self buttonWithImage:@"1247-skip-back-toolbar"
                   selectedImage:@"1247-skip-back-toolbar-selected"
                          target:self
                          action:@selector(skipBack:)];
}

- (UIBarButtonItem *)playButton {
    return [self buttonWithImage:@"1241-play-toolbar"
                   selectedImage:@"1241-play-toolbar-selected"
                          target:self
                          action:@selector(playPause:)];
}

- (UIBarButtonItem *)skipForwardButton {
    return [self buttonWithImage:@"1248-skip-ahead-toolbar"
                   selectedImage:@"1248-skip-ahead-toolbar-selected"
                          target:self
                          action:@selector(skipForward:)];
}

- (void)skipBack:(id)sender {
    [self.playerBarDelegate playerBarPreviousTrack:self];
}

- (void)skipForward:(id)sender {
    [self.playerBarDelegate playerBarNextTrack:self];
}

- (void)playPause:(id)sender {
    [self.playerBarDelegate playerBarPlayPause:self];
}

@end
