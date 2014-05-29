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

@interface MasterViewController () <NSFetchedResultsControllerDelegate> {
    NSMutableSet *_movedIndexPaths;
}

@property (nonatomic, strong) SyncController *syncController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.syncController = [[SyncController alloc] initWithPersistenceController:self.persistenceController];
    [self.syncController syncEpisodes];
    
    [self refresh];
}

- (void)refresh {
    NSError *fetchError;
    if(![self.fetchedResultsController performFetch:&fetchError]) {
        NSLog(@"Couldn't fetch:%@", fetchError);
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Episode"];
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO] ];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.persistenceController.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodeCell *cell = (EpisodeCell *)[tableView dequeueReusableCellWithIdentifier:@"episodeCell"];
    NSManagedObject *mob = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Episode *episode = [MTLManagedObjectAdapter modelOfClass:[Episode class]
                                           fromManagedObject:mob
                                                       error:nil];
    
    cell.titleLabel.text = episode.title;
    cell.descriptionLabel.text = episode.episodeDescription;
    cell.thumbnailImageView.imageURL = episode.thumbnailImageUrl;
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _movedIndexPaths = [NSMutableSet set];
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:[_movedIndexPaths allObjects]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [_movedIndexPaths addObject:newIndexPath];
            
            
            break;
            
        default:
            break;
    }
}

@end
