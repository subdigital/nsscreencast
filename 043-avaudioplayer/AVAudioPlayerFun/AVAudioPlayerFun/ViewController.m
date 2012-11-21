//
//  ViewController.m
//  AVAudioPlayerFun
//
//  Created by Ben Scheirman on 11/20/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (NSString *)audioFilename {
    return @"angry-chair.mp3";
}

- (NSURL *)localAudioFileURL {
    return [[NSBundle mainBundle] URLForResource:[self audioFilename] withExtension:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self localAudioFileURL]
                                                              error:nil];
    self.audioPlayer.meteringEnabled = YES;
    self.volumeSlider.value = 1.0f;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(songTick)
                                   userInfo:nil
                                    repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(setAudioLevels)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)songTick {
    if (![self.audioPlayer isPlaying]) {
        return;
    }
    
    NSTimeInterval totalTime = [self.audioPlayer duration];
    NSTimeInterval currentTime = [self.audioPlayer currentTime];
    CGFloat progress = currentTime / totalTime;
    self.songProgressView.progress = progress;
}

- (void)setAudioLevels {
    if (![self.audioPlayer isPlaying]) {
        return;
    }
    
    [self.audioPlayer updateMeters];
    [self.audioLevelsView setNumberOfChannels:self.audioPlayer.numberOfChannels];
    
    for (int c=0; c<self.audioPlayer.numberOfChannels; c++) {
        float level = [self.audioPlayer averagePowerForChannel:c];
        
        // 0    LOUD
        // -160 SILENT
        [self.audioLevelsView setLevel:level forChannel:c];
    }
}

- (IBAction)onVolumeChanged:(id)sender {
    self.audioPlayer.volume = self.volumeSlider.value;
}

- (IBAction)playPauseTapped:(id)sender {
    BOOL isPlaying = [self.audioPlayer isPlaying];
    if (isPlaying) {
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.audioPlayer pause];
    } else {
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.audioPlayer play];
    }
}
@end
