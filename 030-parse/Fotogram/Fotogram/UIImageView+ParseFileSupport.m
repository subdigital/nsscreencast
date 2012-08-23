//
//  UIImageView+ParseFileSupport.m
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "UIImageView+ParseFileSupport.h"

@implementation UIImageView (ParseFileSupport)

- (void)setFile:(PFFile *)file {
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            self.image = image;
        } else {
            self.image = nil;
            NSLog(@"ERROR: %@", error);
        }
    }];
}

@end
