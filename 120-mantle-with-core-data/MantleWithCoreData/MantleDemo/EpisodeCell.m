//
//  EpisodeCell.m
//  MantleDemo
//
//  Created by ben on 5/10/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "EpisodeCell.h"

@implementation EpisodeCell

- (void)prepareForReuse {
    self.imageView.image = nil;
}

@end
