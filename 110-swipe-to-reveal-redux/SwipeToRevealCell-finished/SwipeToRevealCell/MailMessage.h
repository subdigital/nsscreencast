//
//  MailMessage.h
//  SwipeToRevealCell
//
//  Created by ben on 2/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailMessage : NSObject

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *preview;

@end
