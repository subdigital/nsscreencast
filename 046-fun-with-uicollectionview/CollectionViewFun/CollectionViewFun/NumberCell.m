//
//  NumberCell.m
//  CollectionViewFun
//
//  Created by ben on 12/17/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "NumberCell.h"

@implementation NumberCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.autoresizesSubviews = YES;
        self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleHeight);
        self.label.font = [UIFont boldSystemFontOfSize:42];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.label];
        
        [self setNumber:0];
    }
    return self;
}

- (void)setNumber:(NSInteger)number {
    self.label.text = [NSString stringWithFormat:@"%d", number];
}

@end
