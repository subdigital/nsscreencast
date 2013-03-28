//
//  NSCChatViewController.m
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCChatViewController.h"
#import "MessageInputView.h"
#import "NSCMessage.h"

@interface NSCChatViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSTimer *fetchTimer;
@property (nonatomic, strong) NSDate *lastFetchDate;

@end

@implementation NSCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.room.name;
    
    // TODO
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)fetchMessages {
    // TODO
}

@end
