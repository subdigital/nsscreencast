//
//  ImageCell.m
//  InstagramClient
//
//  Created by ben on 6/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    return self;
}

@end
