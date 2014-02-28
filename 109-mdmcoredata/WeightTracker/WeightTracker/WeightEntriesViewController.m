//
//  WeightEntriesViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "WeightEntriesViewController.h"
#import <CoreData/CoreData.h>
#import "WTWeightLog.h"

@interface WeightEntriesViewController () <MDMFetchedResultsTableDataSourceDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MDMFetchedResultsTableDataSource *dataSource;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation WeightEntriesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // fix a jumping nav bar bug in iOS 7 http://stackoverflow.com/a/19265558/3381
    [self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Recent Entries";
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self recentEntriesFetchRequest]
                                                                        managedObjectContext:self.persistenceController.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"ERROR FETCHING: %@", [error localizedDescription]);
    }

    self.dataSource = [[MDMFetchedResultsTableDataSource alloc] initWithTableView:self.tableView
                                                         fetchedResultsController:self.fetchedResultsController];
    self.dataSource.reuseIdentifier = @"entryCell";
    self.dataSource.delegate = self;

    self.tableView.dataSource = self.dataSource;
}

- (NSFetchRequest *)recentEntriesFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[WTWeightLog MDMCoreDataAdditionsEntityName]];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"dateTaken" ascending:NO] ];
    return fetchRequest;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateStyle:NSDateFormatterShortStyle];
    });
    
    return __dateFormatter;
}

#pragma mark - MDMFetchedResultsTableDataSourceDelegate

- (void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource configureCell:(id)cell_ withObject:(id)object {
    UITableViewCell *cell = cell_;
    WTWeightLog *log = object;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", log.weight, log.units];
    cell.detailTextLabel.text = [[self dateFormatter] stringFromDate:log.dateTaken];
}

-(void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    // not supported yet
}

@end
