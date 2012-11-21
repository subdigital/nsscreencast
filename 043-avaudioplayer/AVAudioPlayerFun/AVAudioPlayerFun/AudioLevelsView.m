//
//  AudioLevelsView.m
//  PlayingMusic
//
//  Created by Ben Scheirman on 11/20/12.
//  Copyright (c) 2012 example. All rights reserved.
//

#import "AudioLevelsView.h"

#define MAX_CHANNELS 8

@implementation AudioLevelsView {
    float levels[MAX_CHANNELS];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfChannels = 1;
        for (int i=0; i<MAX_CHANNELS; i++) {
            levels[i] = 0;
        }
    }
    return self;
}

- (void)setLevel:(CGFloat)level forChannel:(NSInteger)channel {
    NSAssert(channel >= 0 && channel < MAX_CHANNELS, @"Invalid channel: %d", channel);
    levels[channel] = level;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat margin = self.numberOfChannels > 1 ? 0 : 2;
    for (int c = 0; c<self.numberOfChannels; c++) {
        float width = self.frame.size.width / self.numberOfChannels - margin;
        float x = width * c;
        float height = self.frame.size.height;
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextFillRect(context, CGRectMake(x, 0, width, self.frame.size.height));
        
        CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
        
        float normalizedLevel = ((levels[c] + 160) / 160.f) * 0.85;
        float levelHeight = height * normalizedLevel;
        CGContextFillRect(context, CGRectMake(x, height - levelHeight, width, levelHeight));
    }
}

@end
