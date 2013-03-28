//
//  NSCMessage.m
//  NSScreencastChat
//
//  Created by ben on 3/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCMessage.h"

@implementation NSCMessage

+ (NSCMessage *)messageWithDictionary:(NSDictionary *)dictionary {
    NSCMessage *msg = [[NSCMessage alloc] init];
    msg.messageId = [dictionary[@"id"] intValue];
    msg.roomId = [dictionary[@"roomId"] intValue];
    msg.text = dictionary[@"text"];
    msg.author = dictionary[@"author"];
    msg.userId = dictionary[@"userId"];
    return msg;
}

- (NSDictionary *)attributes {
    return @{
             @"text": self.text,
             @"roomId": @(self.roomId),
            };
}

- (NSUInteger)hash {
    return [[NSString stringWithFormat:@"NSCRMessage:%d", self.messageId] hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[NSCMessage class]]) {
        return NO;
    }
    
    NSCMessage *other = (NSCMessage *)object;
    return other.messageId == self.messageId;
}

@end
