//
//  TwitterUserCell+TwitterFollower.m
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "TwitterUserCell+TwitterFollower.h"
#import "UIImageView+AFNetworking.h"

@implementation TwitterUserCell (TwitterFollower)

- (void)configureForFollower:(TwitterFollower *)follower {
    self.nameLabel.text = follower.fullName;
    self.screenNameLabel.text = follower.username;
    UIImage *placeholderImage = [UIImage imageNamed:@"avatar"];
    [self.avatarImageView setImageWithURL:follower.avatarURL
                         placeholderImage:placeholderImage];
}

@end
