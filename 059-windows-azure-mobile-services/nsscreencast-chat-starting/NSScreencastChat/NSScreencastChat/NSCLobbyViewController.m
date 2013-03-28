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
}


- (void)setupClient {
    // TODO
}

- (IBAction)addRoomTapped:(id)sender {
    // TODO
}

- (void)fetchRooms {
    // TODO
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
}

@end
