//
//  ViewController.m
//  LayoutFun
//
//  Created by Ben Scheirman on 8/17/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSLayoutConstraint *leftWidthConstraint;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *headlineView;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) NSArray *verticalConstraints;
@property (nonatomic) BOOL expanded;
@property (nonatomic) BOOL accessoryVisible;

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
    self.headlineView = headlineView;
    
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
    self.leftView = leftView;
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftViewTap:)]];
    
    self.leftWidthConstraint = [self leftWidthConstraintWithMultiplier:0.3];
    [self.view addConstraint:self.leftWidthConstraint];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Tap Me" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    self.accessoryView = [[UIView alloc] init];
    self.accessoryView.backgroundColor = [UIColor blueColor];
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.accessoryView];
    
    NSLayoutConstraint *accessoryWidth = [NSLayoutConstraint constraintWithItem:self.accessoryView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.leftView
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:accessoryWidth];
    
    self.verticalConstraints = [self verticalConstraintsWithAccessoryViewVisible:NO];
    [self.view addConstraints:self.verticalConstraints];
    
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[leftView]-[button]"
                                             options:NSLayoutFormatAlignAllCenterY
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(leftView, button)]
     ];
}

- (NSArray *)verticalConstraintsWithAccessoryViewVisible:(BOOL)visible {
    NSDictionary *metrics = @{
                              @"topPadding": visible ? @40 : @60,
                              @"headlineViewHeight": visible ? @80 : @100,
                              @"accessoryPadding": visible ? @8 : @0,
                              @"accessoryHeight" : visible ? @100 : @0
                              };
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topPadding)-[_headlineView(headlineViewHeight)]-[_leftView]-(accessoryPadding)-[_accessoryView(accessoryHeight)]-|"
                                             options:NSLayoutFormatAlignAllLeft
                                             metrics:metrics
                                                     views:NSDictionaryOfVariableBindings(_headlineView, _leftView, _accessoryView)];
}

- (NSLayoutConstraint *)leftWidthConstraintWithMultiplier:(CGFloat)multiplier {
    return [NSLayoutConstraint constraintWithItem:self.leftView
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.headlineView
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:multiplier
                                         constant:0];
}

- (void)onButtonTap:(id)sender {
    CGFloat multiplier = self.expanded ? 0.3 : 0.7;
    self.expanded = !self.expanded;
    [self.view removeConstraint:self.leftWidthConstraint];
    self.leftWidthConstraint = [self leftWidthConstraintWithMultiplier:multiplier];
    [self.view addConstraint:self.leftWidthConstraint];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:4
                        options:0
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)onLeftViewTap:(id)sender {
    self.accessoryVisible = !self.accessoryVisible;
    [self.view removeConstraints:self.verticalConstraints];
    self.verticalConstraints = [self verticalConstraintsWithAccessoryViewVisible:self.accessoryVisible];
    [self.view addConstraints:self.verticalConstraints];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:4
                        options:0
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

@end
