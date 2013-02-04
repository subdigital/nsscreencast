//
//  BeerStylesViewController.m
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeerStylesViewController.h"
#import "BeersViewController.h"
#import <RestKit/RestKit.h>
#import "BeerStyle.h"
#import "BeerStyleCell.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import "BeerInfoDataModel.h"

@interface BeerStylesViewController ()

@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, strong) BeerStyle *selectedStyle;

@end

@implementation BeerStylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadBeerStyles];
    });
}

- (void)loadBeerStyles {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider beerStyleMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                       pathPattern:@"/v2/styles"
                                                                                           keyPath:@"data"
                                                                                       statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.brewerydb.com/v2/styles?key=%@",
                                       BREWERY_DB_API_KEY
                                       ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request
                                                                                      responseDescriptors:@[responseDescriptor]];
    RKManagedObjectStore *store = [[BeerInfoDataModel sharedDataModel] objectStore];
    operation.managedObjectCache = store.managedObjectCache;
    operation.managedObjectContext = store.mainQueueManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.styles = mappingResult.array;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request failed"];
    }];
    
    [operation start];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"beerStyleCell";
    BeerStyleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BeerStyle *style = [self.styles objectAtIndex:indexPath.row];
    [self configureCell:cell forBeerStyle:style];
    return cell;
}

- (void)configureCell:(BeerStyleCell *)cell forBeerStyle:(BeerStyle *)style {
    cell.styleNameLabel.text = style.name;
    cell.styleDescriptionLabel.text = style.styleDescription;
    cell.styleCategoryLabel.text = style.category;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BeersViewController *beersViewController = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.selectedStyle = [self.styles objectAtIndex:indexPath.row];
    beersViewController.beerStyle = self.selectedStyle;
}

@end
