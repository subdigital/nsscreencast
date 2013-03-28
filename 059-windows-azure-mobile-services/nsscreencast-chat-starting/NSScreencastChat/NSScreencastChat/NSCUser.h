//
//  NSCUser.h
//  NSScreencastChat
//
//  Created by ben on 3/21/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCUser : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *deviceToken;

- (NSDictionary *)attributes;

@end
