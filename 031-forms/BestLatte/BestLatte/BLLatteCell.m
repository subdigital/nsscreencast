//
//  BLLatteCell.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLLatteCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BLLatteCell

@synthesize imageView = _imageView;

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"coffee-nophoto.png"];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.image = [self defaultImage];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame reuseIdentifier:[[self class] description]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self bringSubviewToFront:self.imageView];
}

- (void)setLatte:(BLLatte *)latte {
    NSURL *imageUrl = [NSURL URLWithString:latte.thumbnailUrl];
    [self.imageView setImageWithURL:imageUrl placeholderImage:[self defaultImage]];
    
    [self setNeedsDisplay];
}

@end
