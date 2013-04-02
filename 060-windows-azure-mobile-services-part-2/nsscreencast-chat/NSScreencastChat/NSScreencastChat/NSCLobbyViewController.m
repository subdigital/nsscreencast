//
//  NSCLobbyViewController.m
//  NSScreencastChat
//
//  Created by ben on 3/9/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "NSCLobbyViewController.h"
#import "WindowsAzureMobileServices.h"
#import "NSCRoom.h"
#import "NSCSignInViewController.h"
#import "NSCChatViewController.h"

typedef void (^RoomNameBlock)(NSString *name);

@interface NSCLobbyViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) RoomNameBlock roomNameBlock;
@property (nonatomic, strong) NSCRoom *selectedRoom;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) NSMutableArray *rooms;

@end

@implementation NSCLobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self setupClient];
    [self onRefresh:nil];
}

- (void)onRefresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [self fetchRooms];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.client.currentUser) {
        [self signIn];
    } else {
        [self setupSignOutButton];
    }
}

- (void)setupSignOutButton {
    [self.navigationItem.leftBarButtonItem setTitle:@"Sign out"];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(signOut)];
}

- (void)setupSignInButton {
    [self.navigationItem.leftBarButtonItem setTitle:@"Sign In"];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(signIn)];
}

- (void)signIn {
    [self performSegueWithIdentifier:@"signInSegue" sender:self];
}

- (void)signOut {
    self.client.currentUser = nil;
    [self setupSignInButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"signInSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        NSCSignInViewController *signInVC = (NSCSignInViewController *)nav.topViewController;
        signInVC.client = self.client;
    }
}

- (void)setupClient {
    self.client = [MSClient clientWithApplicationURLString:@"https://nsscreencast-chat-demo.azure-mobile.net/"
                                        withApplicationKey:@"zsARNYoxUFnkIqlsThCaVNhZGDTOhb39"];
}

- (BOOL)promptIfNoUserOrContinue {
    if (!self.client.currentUser) {
        [self signIn];
        return NO;
    }
    
    return YES;
}

- (void)promptForRoomNameWithBlock:(RoomNameBlock)block {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Room Name"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    self.roomNameBlock = block;
    [alertView show];
}

- (IBAction)addRoomTapped:(id)sender {
    if ([self promptIfNoUserOrContinue]) {
        [self promptForRoomNameWithBlock:^(NSString *name) {
            [self addRoomWithName:name];
        }];
    }
}

- (void)addRoomWithName:(NSString *)name {
    NSCRoom *room = [[NSCRoom alloc] init];
    room.name = name;
    
    MSTable *roomsTable = [self.client getTable:@"Rooms"];
    [roomsTable insert:[room attributes]
            completion:^(NSDictionary *item, NSError *error) {
                NSCRoom *room = [[NSCRoom alloc] initWithDictionary:item];
                [self insertRoomRow:room];
            }];
}

- (void)insertRoomRow:(NSCRoom *)room {
    [self.rooms addObject:room];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rooms.count - 1
                                                inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)fetchRooms {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    MSQuery *query = [[self.client getTable:@"Rooms"] query];
    self.rooms = [NSMutableArray array];
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        for (NSDictionary *roomDictionary in items) {
            NSCRoom *room = [[NSCRoom alloc] initWithDictionary:roomDictionary];
            [self.rooms addObject:room];
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *roomName = textField.text;
    if (self.roomNameBlock) {
        self.roomNameBlock(roomName);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSCRoom *room = self.rooms[indexPath.row];
    cell.textLabel.text = room.name;
    
    NSString *participantText = [NSString stringWithFormat:@"%d participant%@", room.participantCount, (room.participantCount == 1 ? @"" : @"s")];
    cell.detailTextLabel.text = participantText;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self promptIfNoUserOrContinue]) {
        NSCChatViewController *chatVC = [[NSCChatViewController alloc] init];
        chatVC.client = self.client;
        chatVC.room = self.rooms[indexPath.row];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

@end
