//
//  ViewController.m
//  PopDemo
//
//  Created by Ben Scheirman on 5/18/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"
#import "Pop.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tapView:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anim.toValue = [NSValue valueWithCGPoint:location];
    anim.springBounciness = 20;
    anim.springSpeed = 1;
    
    [self.imageView.layer pop_addAnimation:anim forKey:@"move"];
}

- (IBAction)tap:(UITapGestureRecognizer *)recognizer {
    
    const CGFloat LargeSize = 256.0f;
    const CGFloat SmallSize = 64.0f;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    
    if (self.imageView.frame.size.width >= LargeSize) {
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, SmallSize, SmallSize)];
    } else {
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, LargeSize, LargeSize)];
    }
    
    anim.springSpeed = 10;
    anim.springBounciness = 10;
    [self.imageView.layer pop_addAnimation:anim forKey:@"scale"];
}

- (IBAction)pan:(UIPanGestureRecognizer *)recognizer {
    [self.imageView.layer pop_removeAnimationForKey:@"move"];
    [self.imageView.layer pop_removeAnimationForKey:@"slide"];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:self.view];
            CGPoint center = self.imageView.center;
            center.x += translation.x;
            center.y += translation.y;
            self.imageView.center = center;
            [recognizer setTranslation:CGPointZero inView:self.view];
            
            break;
        }
            
            
            
        case UIGestureRecognizerStateEnded: {
            POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
            anim.deceleration = 0.998;
            anim.velocity = [NSValue valueWithCGPoint:[recognizer velocityInView:self.view]];
            [self.imageView.layer pop_addAnimation:anim forKey:@"slide"];
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
}

@end
