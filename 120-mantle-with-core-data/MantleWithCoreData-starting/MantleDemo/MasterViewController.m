//
//  MasterViewController.m
//  MantleDemo
//
//  Created by Ben Scheirman on 4/19/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "MasterViewController.h"
#import "Episode.h"
#import "SyncController.h"
#import "EpisodeCell.h"
#import "AsyncImageView.h"

@interface MasterViewController ()

@property (nonatomic, strong) SyncController *syncController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.syncController = [[SyncController alloc] initWithPersistenceController:self.persistenceController];
    [self.syncController syncEpisodes];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodeCell *cell = (EpisodeCell *)[tableView dequeueReusableCellWithIdentifier:@"episodeCell"];
    return cell;
}

@end
