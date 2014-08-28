//
//  ViewController.m
//  LayoutFun
//
//  Created by Ben Scheirman on 8/17/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     
      -------------------
     | ****************  |
     | ****************  |
     | ....              |
     | ....  ooo         |
     | ....              |
     |                   |
      -------------------
     
    */
    
    UIView *headlineView = [[UIView alloc] init];
    headlineView.backgroundColor = [UIColor colorWithRed:0.423 green:0.343 blue:0.804 alpha:1.000];
    headlineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headlineView];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-[headlineView]-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(headlineView)]
     ];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithRed:0.725 green:0.739 blue:1.000 alpha:1.000];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:leftView];
    
    
    NSDictionary *metrics = @{
                              @"topPadding": @60,
                              @"headlineViewHeight": @100
                              };
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topPadding)-[headlineView(headlineViewHeight)]-[leftView]-|"
                                             options:NSLayoutFormatAlignAllLeft
                                             metrics:metrics
                                               views:NSDictionaryOfVariableBindings(headlineView, leftView)]
     ];
    NSLayoutConstraint *leftWidth = [NSLayoutConstraint constraintWithItem:leftView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headlineView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:0];
    [self.view addConstraint:leftWidth];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Tap Me" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:button];
    
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[leftView]-[button]"
                                             options:NSLayoutFormatAlignAllCenterY
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(leftView, button)]
     ];
}

@end
