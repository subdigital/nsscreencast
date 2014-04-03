//
//  GTViewController.m
//  GiggleTouch
//
//  Created by ben on 3/17/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "GTViewController.h"
#import "GTMyScene.h"

@implementation GTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [GTMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
}

@end
