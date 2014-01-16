//
//  TwitterFollower.m
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "TwitterFollower.h"

@implementation TwitterFollower

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.username = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        self.fullName = dictionary[@"name"];
        self.avatarURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
    }
    
    return self;
}

@end
