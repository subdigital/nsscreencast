//
//  OILEntriesViewController.m
//  OilChangeApp
//
//  Created by ben on 5/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "OILEntriesViewController.h"
#import "OILDataModel.h"
#import "OILEntry+Custom.h"
#import "OILEntryCell.h"

@interface OILEntriesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OILEntriesViewController

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Oil Changes";
    
    self.context = [[OILDataModel shareDataModel] mainContext];
    [self setupFetchedResultsController];
    [self listenForChanges];
}

- (void)onEdit:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.editing = !self.tableView.editing;
    }];
    
    NSString *title = @"Edit";
    if (self.tableView.editing) {
        title = @"Cancel";
    }
    
    [self.navigationItem.leftBarButtonItem setTitle:title];
}

- (void)listenForChanges {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidChange:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (void)contextDidChange:(NSNotification *)notification {
    if (notification.object != self.context) {
        [self.context mergeChangesFromContextDidSaveNotification:notification];
        [self.context performBlock:^{
            [self.context save:nil];
        }];
    }
}

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSSortDescriptor *sortByDateDesc = [NSSortDescriptor sortDescriptorWithKey:@"miles" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByDateDesc]];
    return fetchRequest;
}

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest]
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"entryCell";
    OILEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    OILEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell forEntry:entry];
    
    return cell;
}

- (void)configureCell:(OILEntryCell *)cell forEntry:(OILEntry *)entry {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:entry.date];
    cell.milesLabel.text = [NSString stringWithFormat:@"%@", entry.miles];
    cell.logLabel.text = entry.log;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    OILEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.context deleteObject:entry];
    [self.context performBlock:^{
        [self.context save:nil];
    }];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
