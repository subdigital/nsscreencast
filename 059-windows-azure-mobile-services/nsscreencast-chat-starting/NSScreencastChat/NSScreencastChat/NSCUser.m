//
//  NSCUser.m
//  NSScreencastChat
//
//  Created by ben on 3/21/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCUser.h"

@implementation NSCUser

- (NSDictionary *)attributes {
    id deviceTokenValue = self.deviceToken ? self.deviceToken : [NSNull null];
    return @{@"deviceToken": deviceTokenValue, @"roomId": @(0)};
}

@end
