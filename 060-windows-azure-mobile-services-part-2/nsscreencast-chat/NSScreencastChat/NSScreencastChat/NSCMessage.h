//
//  NSCMessage.h
//  NSScreencastChat
//
//  Created by ben on 3/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCMessage : NSObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *text;

+ (NSCMessage *)messageWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)attributes;

@end
