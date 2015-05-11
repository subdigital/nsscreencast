//
//  PlayerBar.m
//  RoadTripDJ
//
//  Created by Ben Scheirman on 2/15/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import "PlayerBar.h"

@interface PlayerBar () {
    UIBarButtonItem *_playButton;
}

@end

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


- (void)setPlayButtonState:(BOOL)isPlaying {
    UIImage *image = nil;
    UIImage *highlightedImage = nil;
    
    if (isPlaying) {
        image = [self templateImageNamed:@"1242-pause-toolbar"];
        highlightedImage = [self templateImageNamed:@"1242-pause-toolbar-selected"];
    } else {
        image = [self templateImageNamed:@"1241-play-toolbar"];
        highlightedImage = [self templateImageNamed:@"1241-play-toolbar-selected"];
    }
    
    UIBarButtonItem *playButtonItem = [self playButton];
    UIButton *button = (UIButton *)playButtonItem.customView;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
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
    UIBarButtonItem *prevButton = [self skipBackButton];
    UIBarButtonItem *playButton = [self playButton];
    UIBarButtonItem *nextButton = [self skipForwardButton];
    
    self.items = @[
                   prevButton,
                   playButton,
                   nextButton,
                   ];
    
    UIView *b1 = prevButton.customView;
    UIView *b2 = playButton.customView;
    UIView *b3 = nextButton.customView;
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[b1]-[b2(==b1)]-[b3(==b1)]-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(b1, b2, b3)];
    for (UIView *b in @[b1, b2, b3]) {

        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[b]-(0)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:NSDictionaryOfVariableBindings(b)];
        constraints = [constraints arrayByAddingObjectsFromArray:verticalConstraints];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    for (UIBarButtonItem *item in self.items) {
        item.enabled = self.enabled;
    }
}

- (UIImage *)templateImageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:name
                                inBundle:bundle
           compatibleWithTraitCollection:self.traitCollection];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIBarButtonItem *)buttonWithImage:(NSString *)imageName
                       selectedImage:(NSString *)selectedImageName
                              target:(id)target
                              action:(SEL)action {

    UIImage *image = [self templateImageNamed:imageName];
    UIImage *selectedImage = [self templateImageNamed:selectedImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    
    [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)skipBackButton {
    return [self buttonWithImage:@"1247-skip-back-toolbar"
                   selectedImage:@"1247-skip-back-toolbar-selected"
                          target:self
                          action:@selector(skipBack:)];
}

- (UIBarButtonItem *)playButton {
    if (_playButton == nil) {
        _playButton = [self buttonWithImage:@"1241-play-toolbar"
                              selectedImage:@"1241-play-toolbar-selected"
                                     target:self
                                     action:@selector(playPause:)];
    }
    
    return _playButton;
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
#if TARGET_IPHONE_SIMULATOR
    static BOOL isPlaying = NO;
    [self setPlayButtonState:isPlaying];
    isPlaying = !isPlaying;
#else
    [self.playerBarDelegate playerBarPlayPause:self];
#endif
}

@end
