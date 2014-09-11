//
//  ViewController.m
//  ConnectFour
//
//  Created by Ben Scheirman on 8/16/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "ViewController.h"
#import "GameBoardView.h"
#import "PieceView.h"

@interface ViewController ()

@property (nonatomic, strong) GameBoardView *gameBoardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameBoardView = [[GameBoardView alloc] initWithRows:6 columns:7];
    [self.view addSubview:self.gameBoardView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_gameBoardView]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_gameBoardView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gameBoardView
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0]];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(spawnPiece:)]];
}

- (void)spawnPiece:(UITapGestureRecognizer *)tap {
    CGSize size = [self.gameBoardView pieceSize];
    CGPoint tapLocation = [tap locationInView:self.view];
    CGPoint point = CGPointMake(tapLocation.x - size.width / 2.0f, tapLocation.y - size.height / 2.0f);
    
    CGRect frame;
    frame.size = size;
    frame.origin = point;
    
    PieceView *piece = [[PieceView alloc] initWithFrame:frame pieceColor:PieceColorRed];
    [self.view insertSubview:piece belowSubview:self.gameBoardView];
    
    [UIView animateWithDuration:0.75
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect newFrame = frame;
                         newFrame.origin.y = self.view.bounds.size.height;
                         piece.frame = newFrame;
                     } completion:^(BOOL finished) {
                         [piece removeFromSuperview];
                     }];
}

@end
