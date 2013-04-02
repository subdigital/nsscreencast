//
//  NSCRoom.m
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCRoom.h"

@implementation NSCRoom

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.roomId = [dictionary[@"id"] intValue];
        self.name = dictionary[@"name"];
        self.participantCount = [dictionary[@"participantCount"] intValue];
    }
    
    return self;
}

- (NSDictionary *)attributes {
    return @{@"name": self.name};
}

@end
