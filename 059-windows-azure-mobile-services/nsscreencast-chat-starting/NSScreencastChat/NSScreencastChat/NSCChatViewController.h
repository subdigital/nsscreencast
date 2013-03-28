//
//  NSCChatViewController.h
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewController.h"
#import "WindowsAzureMobileServices.h"
#import "NSCRoom.h"
#import "NSCUser.h"

@interface NSCChatViewController : MessagesViewController

@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) NSCUser *user;
@property (nonatomic, strong) NSCRoom *room;

@end
