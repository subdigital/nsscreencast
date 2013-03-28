//
//  NSCRoom.h
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCRoom : NSObject

@property (nonatomic, assign) NSUInteger roomId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger participantCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
