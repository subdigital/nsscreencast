//
//  PusherEventsViewController.m
//  PusherEvents
//
//  Created by Luke Redpath on 22/03/2010.
//  Copyright LJR Software Limited 2010. All rights reserved.
//

#import "PusherEventsViewController.h"
#import "PTPusher.h"
#import "PTPusherEvent.h"
#import "PTPusherChannel.h"
#import "PTPusherAPI.h"
#import "PTPusherConnection.h"
#import "NewEventViewController.h"

@implementation PusherEventsViewController

@synthesize pusher;
@synthesize pusherAPI;
@synthesize currentChannel;
@synthesize eventsReceived;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    eventsReceived = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  self.title = @"Subscribe/Trigger";
  self.tableView.rowHeight = 55;

  UIBarButtonItem *newEventButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentNewEventScreen)];
  self.toolbarItems = [NSArray arrayWithObject:newEventButtonItem];
  [newEventButtonItem release];
  
  // configure the auth URL for private/presence channels
  self.pusher.authorizationURL = [NSURL URLWithString:@"http://localhost:9292/presence/auth"];
  
  [self subscribeToChannel:@"messages"];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self.pusher unsubscribeFromChannel:self.currentChannel]; 
}

- (void)dealloc 
{
  [pusher release];
  [pusherAPI release];
  [currentChannel release];
  [eventsReceived release];
  [super dealloc];
}

#pragma mark - Subscribing

- (void)subscribeToChannel:(NSString *)channelName
{
  self.currentChannel = [self.pusher subscribeToChannelNamed:channelName];
  
  [self.currentChannel bindToEventNamed:@"new-message" handleWithBlock:^(PTPusherEvent *event) {
    [self.tableView beginUpdates];
    [eventsReceived insertObject:event atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
  }];
}

#pragma mark - Actions

- (void)presentNewEventScreen;
{
  NewEventViewController *newEventController = [[NewEventViewController alloc] init];
  newEventController.delegate = self;
  [self presentModalViewController:newEventController animated:YES];
  [newEventController release];
}

- (void)sendEventWithMessage:(NSString *)message;
{
  // construct a simple payload for the event
  NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];

  // send the event after a short delay, wait for modal view to disappear
  [self performSelector:@selector(sendEvent:) withObject:payload afterDelay:0.3];
  [self dismissModalViewControllerAnimated:YES];
}

- (void)sendEvent:(id)payload;
{
  if (self.pusherAPI == nil) {
    PTPusherAPI *api = [[PTPusherAPI alloc] initWithKey:PUSHER_API_KEY appID:PUSHER_APP_ID secretKey:PUSHER_API_SECRET];
    self.pusherAPI = api;
    [api release];
  }
  // we set the socket ID to nil here as we want to receive the events that we are sending
  [self.pusherAPI triggerEvent:@"new-message" onChannel:@"messages" data:payload socketID:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
  return eventsReceived.count;
}

static NSString *EventCellIdentifier = @"EventCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EventCellIdentifier] autorelease];
  }
  PTPusherEvent *event = [eventsReceived objectAtIndex:indexPath.row];

  cell.textLabel.text = event.name;
  cell.detailTextLabel.text = [event.data description];
  
  return cell;
}

@end
