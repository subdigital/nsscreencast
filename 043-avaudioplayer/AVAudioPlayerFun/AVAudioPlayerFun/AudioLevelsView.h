//
//  AudioLevelsView.h
//  PlayingMusic
//
//  Created by Ben Scheirman on 11/20/12.
//  Copyright (c) 2012 example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioLevelsView : UIView

@property (nonatomic, assign) NSInteger numberOfChannels;

- (void)setLevel:(CGFloat)level forChannel:(NSInteger)channel;

@end
