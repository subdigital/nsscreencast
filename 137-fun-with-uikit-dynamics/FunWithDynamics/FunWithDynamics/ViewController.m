//
//  ViewController.m
//  FunWithDynamics
//
//  Created by Ben Scheirman on 9/14/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *square;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIGravityBehavior *gravity;

@property (nonatomic, strong) UICollisionBehavior *collision;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    square.backgroundColor = [UIColor colorWithRed:0.311 green:0.101 blue:0.311 alpha:1.000];
    square.center = self.view.center;
    square.layer.shadowColor = [UIColor blackColor].CGColor;
    square.layer.shadowOffset = CGSizeMake(1, 1);
    square.layer.shadowOpacity = 0.5;
    square.transform = CGAffineTransformMakeRotation(M_PI  / 4.1);
    self.square = square;
    [self.view addSubview:square];
    
    UIView *barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 130, 10)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[ square ]];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[square]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.collision addBoundaryWithIdentifier:@"barrier"
                                      forPath:[UIBezierPath bezierPathWithRect:barrier.frame]];
    
    UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    behavior.elasticity = 0.5;
    behavior.friction = 0.2;
    behavior.angularResistance = 0.5;
    
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:behavior];
    
    [self bump];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bump)];
    [self.view addGestureRecognizer:tap];
}

- (void)bump {
    UIDynamicItemBehavior *bump = [[UIDynamicItemBehavior alloc] initWithItems:@[self.square]];
    [bump addLinearVelocity:CGPointMake(600, -1200) forItem:self.square];
    [self.animator addBehavior:bump];
}

@end
