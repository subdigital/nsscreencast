//
//  UIImageView+ParseFileSupport.h
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UIImageView (ParseFileSupport)

- (void)setFile:(PFFile *)file;

@end
