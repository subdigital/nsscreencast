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
    
    
    NSLayoutConstraint *headlineHeight = [NSLayoutConstraint constraintWithItem:headlineView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:100];
    [headlineView addConstraint:headlineHeight];
    
    
    NSLayoutConstraint *headlineTop = [NSLayoutConstraint constraintWithItem:headlineView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:60];
    [self.view addConstraint:headlineTop];
    
    
    NSLayoutConstraint *headlineLeft = [NSLayoutConstraint constraintWithItem:headlineView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:20];
    [self.view addConstraint:headlineLeft];
    
    NSLayoutConstraint *headlineRight = [NSLayoutConstraint constraintWithItem:headlineView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:-20];
    [self.view addConstraint:headlineRight];
    
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithRed:0.725 green:0.739 blue:1.000 alpha:1.000];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:leftView];
    
    NSLayoutConstraint *leftSide = [NSLayoutConstraint constraintWithItem:leftView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:headlineView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:0];
    [self.view addConstraint:leftSide];
    
    
    // this is needed because....
    NSLayoutConstraint *leftTop = [NSLayoutConstraint constraintWithItem:leftView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headlineView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:20];
    [self.view addConstraint:leftTop];
    
    
    NSLayoutConstraint *leftBottom = [NSLayoutConstraint constraintWithItem:leftView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-20];
    [self.view addConstraint:leftBottom];
    
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
    
    NSLayoutConstraint *buttonLeft = [NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:leftView
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:20];
    [self.view addConstraint:buttonLeft];
    
    NSLayoutConstraint *buttonY = [NSLayoutConstraint constraintWithItem:button
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:leftView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0];
    [self.view addConstraint:buttonY];
}

@end
