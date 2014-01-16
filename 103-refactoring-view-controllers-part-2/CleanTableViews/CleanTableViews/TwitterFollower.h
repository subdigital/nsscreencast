//
//  TwitterFollower.h
//  CleanTableViews
//
//  Created by ben on 1/14/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterFollower : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSURL *avatarURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
