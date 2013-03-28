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
    
    self.lastFetchDate = [NSDate dateWithTimeIntervalSince1970:0];
    [self listenForMessages];
    [self fetchMessages];
}

- (void)listenForMessages {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"NSCMessageReceivedNotification"
                                               object:nil];
}

- (void)onMessageReceived:(NSNotification *)notification {
    NSNumber *roomId = [notification object];
    if ([roomId intValue] == self.room.roomId) {
        [self fetchMessages];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUserRoom:@(self.room.roomId)];
    [self startPolling];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setUserRoom:[NSNull null]];
    [self stopPolling];
}

- (void)startPolling {
    // don't poll if the current device is using push notifications
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
        return;
    }
    
    self.fetchTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self
                                                    selector:@selector(fetchMessages)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopPolling {
    [self.fetchTimer invalidate];
    self.fetchTimer = nil;
}

- (void)setUserRoom:(id)room {
    MSTable *users = [self.client getTable:@"Users"];
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    id params = @{ @"roomId": room, @"id": userId };
    [users update:params completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
        } else {
            NSLog(@"set user room to %@", room);
        }
    }];
}

- (void)fetchMessages {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Checking for messages since %@", self.lastFetchDate);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomId = %d and createdAt > %@", self.room.roomId, self.lastFetchDate];
    MSQuery *query = [[self messagesTable] queryWhere:predicate];
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        self.lastFetchDate = [NSDate date];
        if (items) {
            NSLog(@"Found messages: %@", items);
            if (!self.messages) {
                self.messages = [NSMutableArray array];
                [self.messages addObjectsFromArray:[self messageArrayForDictionaries:items]];
                [self.tableView reloadData];
                [self scrollToBottomAnimated:NO];
            } else {
                NSMutableArray *messagesToAdd = [NSMutableArray array];
                for (id msgDictionary in items) {
                    NSCMessage *message = [NSCMessage messageWithDictionary:msgDictionary];
                    if (![self.messages containsObject:message]) {
                        [messagesToAdd addObject:message];
                    }
                }
                
                if ([messagesToAdd count] > 0) {
                    [self insertMessages:messagesToAdd];
                }
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else {
            NSLog(@"ERROR: %@", error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
}

- (NSArray *)messageArrayForDictionaries:(NSArray *)messageDictionaries {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[messageDictionaries count]];
    for (NSDictionary *dictionary in messageDictionaries) {
        [results addObject:[NSCMessage messageWithDictionary:dictionary]];
    }
    return results;
}

- (MSTable *)messagesTable {
    return [self.client getTable:@"Messages"];
}

- (void)insertMessages:(NSArray *)messages {
    [self.tableView beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[messages count]];
    for (id msg in messages) {
        [self.messages addObject:msg];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages count] - 1
                                                   inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self scrollToBottomAnimated:YES];
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text {
    sender.enabled = NO;
    
    NSCMessage *msg = [[NSCMessage alloc] init];
    msg.text = text;
    msg.roomId = self.room.roomId;
    
    [[self messagesTable] insert:[msg attributes]
                      completion:^(NSDictionary *item, NSError *error) {
                          if (item) {
                              NSCMessage *msg = [NSCMessage messageWithDictionary:item];
                              [self insertMessageRow:msg];
                              [self finishSend];
                              
                          } else {
                              NSLog(@"ERROR: %@", error);
                              [[[UIAlertView alloc] initWithTitle:@"Didn't post your message"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] show];
                          }
                      }];
}

- (void)insertMessageRow:(NSCMessage *)msg {
    [self.messages addObject:msg];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (BOOL)isOwnMessage:(NSCMessage *)msg {
    return [msg.userId isEqualToString:self.client.currentUser.userId];
}

- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCMessage *msg = self.messages[indexPath.row];
    return [self isOwnMessage:msg] ? BubbleMessageStyleOutgoing : BubbleMessageStyleIncoming;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSCMessage *msg = self.messages[indexPath.row];
    if ([self isOwnMessage:msg]) {
        return msg.text;
    } else {
        NSString *text = [NSString stringWithFormat:@"%@\n\n--%@", msg.text, msg.author];
        return text;
    }
}

@end
