//
//  ImageCell.m
//  ImgShare
//
//  Created by Ben Scheirman on 11/1/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ImageCell

- (void)prepareForReuse {
    [self.imageView cancelImageRequestOperation];
    self.imageView.image = nil;
}

@end
