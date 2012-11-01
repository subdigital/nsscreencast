//
//  NSCRNavigationBar.m
//  nsscreencast
//
//  Created by Ben Scheirman on 10/24/12.
//  Copyright (c) 2012 Ben Scheirman. All rights reserved.
//

#import "NSCRNavigationBar.h"

@interface NSCRNavigationBar ()
@property (nonatomic, strong) UIImageView *shadowView;
@end

@implementation NSCRNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;

}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setupBarButtonItemStyles {
    UIImage *bg = [UIImage imageNamed:@"navbar-btn.png"];
    bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearanceWhenContainedIn:[NSCRNavigationBar class], nil]
     setBackgroundImage:bg
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    
    UIImage *bgHighlighted = [UIImage imageNamed:@"navbar-btn-highlighted.png"];
    bgHighlighted = [bgHighlighted resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearanceWhenContainedIn:[NSCRNavigationBar class], nil]
     setBackgroundImage:bgHighlighted
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsDefault];
}

- (void)setupShadow {
    UIImage *shadowImage = [UIImage imageNamed:@"navbar-shadow.png"];
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:shadowView];
    
    self.shadowView = shadowView;
}

- (void)setupNavbarStyles {
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Magra-Bold" size:20], @"font", nil];
    self.titleTextAttributes = titleTextAttributes;
    
    [self setTintColor:[UIColor blackColor]];
    [self setBackgroundImage:[UIImage imageNamed:@"navbar.png"]
               forBarMetrics:UIBarMetricsDefault];
}

- (void)commonInit {
    [self setClipsToBounds:NO];
    [self setupNavbarStyles];
    [self setupBarButtonItemStyles];
    [self setupShadow];
}

+ (UIView *)logoTitleView {
    return [NSCRLogoView logoView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // reposition shadow to be just underneath the bar
    CGRect frame = self.bounds;
    frame.origin.y = self.bounds.size.height;
    frame.size.height = self.shadowView.image.size.height;
    self.shadowView.frame = frame;
}

@end