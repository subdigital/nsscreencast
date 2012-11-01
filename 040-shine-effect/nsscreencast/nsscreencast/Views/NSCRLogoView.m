//
//  NSCRLogoView.m
//  nsscreencast
//
//  Created by Ben Scheirman on 10/27/12.
//  Copyright (c) 2012 Ben Scheirman. All rights reserved.
//

#import "NSCRLogoView.h"
#import <QuartzCore/QuartzCore.h>

@interface NSCRLogoView ()

@end

@implementation NSCRLogoView

+ (id)logoView {
    return [[NSCRLogoView alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setImage:[UIImage imageNamed:@"logo.png"]];
        self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
    return self;
}

- (void)flash {
    CGFloat width = self.image.size.width;
    CGFloat height = self.image.size.height;
    
    CALayer *shineLayer = [CALayer layer];
    UIImage *shineImage = [UIImage imageNamed:@"logo-highlighted.png"];
    shineLayer.contents = (id)[shineImage CGImage];
    shineLayer.frame = CGRectMake(0, 1, width, height);
    
    CALayer *mask = [CALayer layer];
    mask.backgroundColor = [[UIColor clearColor] CGColor];
    UIImage *maskImage = [UIImage imageNamed:@"logo-mask.png"];
    mask.contents = (id)[maskImage CGImage];
    mask.contentsGravity = kCAGravityCenter;
    mask.frame = CGRectMake(-width, 0, width * 1.25, height);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anim.byValue = @(width * 2);
    anim.repeatCount = HUGE_VALF;
    anim.duration = 3.0f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:shineLayer];
    shineLayer.mask = mask;
    
    [mask addAnimation:anim forKey:@"shine"];
}












@end
