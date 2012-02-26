//
//  PusherEventsViewController.m
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "PusherPresenceEventsViewController.h"
#import "PTPusher.h"
#import "PTPusherEvent.h"
#import "PTPusherChannel.h"
#import "PTPusherAPI.h"
#import "PTPusherConnection.h"
#import "NewEventViewController.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "Constants.h"
#import "PusherEventsAppDelegate.h"

@interface PusherPresenceEventsViewController ()
- (PusherEventsAppDelegate *)clientManager;
@end

@implementation PusherPresenceEventsViewController

@synthesize pusher = _pusher;
@synthesize currentChannel;

- (PusherEventsAppDelegate *)clientManager
{
  return (PusherEventsAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  self.title = @"Presence";
  self.tableView.rowHeight = 55;

  UIBarButtonItem *newClientButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Client" style:UIBarButtonItemStyleBordered target:self action:@selector(connectClient)];
  UIBarButtonItem *disconnectClientButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove Client" style:UIBarButtonItemStyleBordered target:self action:@selector(disconnectLastClient)];
  self.toolbarItems = [NSArray arrayWithObjects:newClientButtonItem, disconnectClientButtonItem, nil];
  [newClientButtonItem release];
  [disconnectClientButtonItem release];
  
  // configure the auth URL for private/presence channels
  self.pusher.authorizationURL = [NSURL URLWithString:@"http://localhost:9292/presence/auth"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self subscribeToPresenceChannel:@"demo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  if ([self.currentChannel isSubscribed]) {
    // unsubscribe before we go back to the main menu
    [self.pusher unsubscribeFromChannel:self.currentChannel];
  }
}

- (void)dealloc 
{
  [_pusher release];
  [currentChannel release];
  [super dealloc];
}

#pragma mark - Subscribing

- (void)subscribeToPresenceChannel:(NSString *)channelName
{
  self.currentChannel = [self.pusher subscribeToPresenceChannelNamed:channelName delegate:self];
}

#pragma mark - Actions

- (void)connectClient
{
  PTPusher *client = [[self clientManager] createClientWithAutomaticConnection:YES];
  client.authorizationURL = self.pusher.authorizationURL;
  [client subscribeToPresenceChannelNamed:@"demo"];
}

- (void)disconnectLastClient
{
  [[[self clientManager] lastConnectedClient] disconnect];
}

#pragma mark - Presence channel events

- (void)presenceChannel:(PTPusherPresenceChannel *)channel didSubscribeWithMemberList:(NSArray *)members
{
  NSLog(@"[pusher] Channel members: %@", members);
  [self.tableView reloadData];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberAddedWithID:(NSString *)memberID memberInfo:(NSDictionary *)memberInfo
{
  NSLog(@"[pusher] Member joined channel: %@", memberInfo);
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[channel.memberIDs indexOfObject:memberID] inSection:0]]
                        withRowAnimation:UITableViewRowAnimationTop];
  [self.tableView endUpdates];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberRemovedWithID:(NSString *)memberID atIndex:(NSInteger)index
{
  NSLog(@"[pusher] Member left channel: %@", memberID);

  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] 
                        withRowAnimation:UITableViewRowAnimationTop];
  [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
  return self.currentChannel.memberCount;
}

static NSString *EventCellIdentifier = @"EventCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EventCellIdentifier] autorelease];
  }
  NSString *memberID = [self.currentChannel.memberIDs objectAtIndex:indexPath.row];
  NSDictionary *memberInfo = [self.currentChannel infoForMemberWithID:memberID];

  cell.textLabel.text = [NSString stringWithFormat:@"Member: %@", memberID];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Name: %@ Email: %@", [memberInfo objectForKey:@"name"], [memberInfo objectForKey:@"email"]];
  
  return cell;
}

@end
