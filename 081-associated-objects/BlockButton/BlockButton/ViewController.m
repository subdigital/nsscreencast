//
//  ViewController.m
//  BlockButton
//
//  Created by ben on 8/2/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Blocks.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    [self.button addTargetWithBlock:^{
        __strong ViewController *strongSelf = weakSelf;
        [strongSelf setRandomColor];
    }];
    
    
    //alert view + handler
    //alert view 2 + handler
}


- (void)setRandomColor {
    CGFloat r = (arc4random() % 255) / 255.0f;
    CGFloat g = (arc4random() % 255) / 255.0f;
    CGFloat b = (arc4random() % 255) / 255.0f;
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
    self.view.backgroundColor = color;
}



@end
