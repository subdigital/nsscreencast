//
//  MasterViewController.m
//  SwipeToRevealCell
//
//  Created by ben on 2/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "MasterViewController.h"
#import "MailMessage.h"
#import "MailMessageCell.h"

@interface MasterViewController () {
}
@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.messages) {
        [self loadTestMessages];
    }
}

- (void)loadTestMessages {
    NSArray *senders  = @[@"Barack Obama", @"Edward Snowden", @"Nobel Peace Prize Committee", @"Mr. Prince Ndibe", @"David Gilmour"];
    NSArray *dateStrs = @[@"2/1/14", @"2/2/14", @"2/4/14", @"2/4/14", @"2/6/14"];
    NSArray *subjects = @[@"Dinner Invite", @"Get those files I sent?", @"Nomination", @"Need US Advocate", @"Jam Session?"];
    NSArray *previews = @[@"Are you free for dinner this weekend?", @"Hey did you get those files I sent...?", @"You've been nominated for...",
                          @"Greetings of the day....", @"We should jam soon. Call me."];
    
    self.messages = [NSMutableArray array];
    [senders enumerateObjectsUsingBlock:^(NSString *sender, NSUInteger idx, BOOL *stop) {
        MailMessage *msg = [[MailMessage alloc] init];
        msg.sender = sender;
        msg.dateString = dateStrs[idx];
        msg.subject = subjects[idx];
        msg.preview = previews[idx];
        [self.messages addObject:msg];
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    MailMessage *msg = self.messages[indexPath.row];
    
    cell.senderLabel.text = msg.sender;
    cell.subjectLabel.text = msg.subject;
    cell.previewLabel.text = msg.preview;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
