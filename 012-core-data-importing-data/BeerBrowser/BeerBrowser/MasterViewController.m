//
//  MasterViewController.m
//  CoreDataBasics
//
//  Created by Ben Scheirman on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "BeersDataModel.h"
#import "Brewery.h"

@interface MasterViewController () {
    MBProgressHUD *_hud;
    NSFetchedResultsController *_fetchedResultsController;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Breweries";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];

    [self setupRefreshButton];
    [self loadBreweries];
}

- (void)contextDidSave:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSManagedObjectContext *mainContext = [[BeersDataModel sharedDataModel] mainContext];
        [mainContext mergeChangesFromContextDidSaveNotification:notification];
        
        [self loadBreweries];
        [self.tableView reloadData];
    });
}

- (void)loadBreweries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Brewery entityName]];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"name", @"city", @"state", @"country", nil]];
    [fetchRequest setFetchBatchSize:40];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[[BeersDataModel sharedDataModel] mainContext]
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    [_fetchedResultsController performFetch:nil];
}

- (void)setupRefreshButton {
    id refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                     target:self 
                                                                     action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)refresh:(id)sender {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [_hud setMode:MBProgressHUDModeIndeterminate];
    [_hud setLabelText:@"Fetching..."];
    [self.view addSubview:_hud];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/breweries.json"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *op;
    op = [AFJSONRequestOperation JSONRequestOperationWithRequest:req
                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                             [self parseBreweries:JSON];
                                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                     NSError *error, id JSON) {
                                                             [self displayError];
                                                         }];
    
    [_hud show:YES];
    [op start];
}

- (void)displayError {
    [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                message:@"An error occurred."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)parseBreweries:(id)breweries {
    [_hud setMode:MBProgressHUDModeDeterminate];
    [_hud setProgress:0];
    [_hud setLabelText:@"Importing..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger totalRecords = [breweries count];
        NSInteger currentRecord = 0;
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[[BeersDataModel sharedDataModel] persistentStoreCoordinator]];
        
        for (NSDictionary *dictionary in breweries) {
            NSInteger serverId = [[dictionary objectForKey:@"id"] intValue];
            Brewery *brewery = [Brewery breweryWithServerId:serverId usingManagedObjectContext:context];
            if (brewery == nil) {
                brewery = [Brewery insertInManagedObjectContext:context];
                [brewery setServerId:[NSNumber numberWithInteger:serverId]];
            }
            
            [brewery updateAttributes:dictionary];
            
            currentRecord++;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                float percent = ((float)currentRecord)/totalRecords;
                [_hud setProgress:percent];
            });
        }
        
        NSError *error = nil;
        if ([context save:&error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud setLabelText:@"Done!"];
                [_hud hide:YES afterDelay:2.0];
            });
        } else {
            NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
            exit(1);
        }
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Brewery *brewery = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = brewery.name;
    
    NSString *locale = brewery.state;
    if (!locale) {
        locale = brewery.country;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", brewery.city, locale];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    NSDate *object = nil;
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
