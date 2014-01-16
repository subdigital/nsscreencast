//
//  TwitterUserCell+TwitterFollower.h
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "TwitterUserCell.h"
#import "TwitterFollower.h"

@interface TwitterUserCell (TwitterFollower)

- (void)configureForFollower:(TwitterFollower *)follower;

@end
