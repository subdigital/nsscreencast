//
//  GTViewController.m
//  GiggleTouch
//
//  Created by ben on 3/17/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "GTViewController.h"
#import "GTMyScene.h"
@import AVFoundation;

@interface GTViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation GTViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startBackgroundMusic];

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

- (void)startBackgroundMusic {
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"background-music-loop" withExtension:@"caf"];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    if (self.audioPlayer) {
        self.audioPlayer.numberOfLoops = -1;
        self.audioPlayer.volume = 0.4;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    } else {
        NSLog(@"Couldn't initialize audio player: %@   Audio URL: %@", error, musicURL);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
}

@end
