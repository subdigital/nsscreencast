//
//  ViewController.h
//  AVAudioPlayerFun
//
//  Created by Ben Scheirman on 11/20/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioLevelsView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;
@property (weak, nonatomic) IBOutlet AudioLevelsView *audioLevelsView;
- (IBAction)onVolumeChanged:(id)sender;
- (IBAction)playPauseTapped:(id)sender;

@end
