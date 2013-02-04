//
//  BeersViewController.m
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeersViewController.h"
#import "BeerCell.h"
#import "Beer.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import "BeerInfoDataModel.h"

@interface BeersViewController ()

@property (nonatomic, strong) NSArray *beers;

@end

@implementation BeersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.beerStyle) {
        [SVProgressHUD show];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self loadBeers];
        });
    }
}

- (void)loadBeers {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKMapping *mapping = [MappingProvider beerMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                       pathPattern:@"/v2/beers"
                                                                                           keyPath:@"data"
                                                                                       statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.brewerydb.com/v2/beers?styleId=%@&withBreweries=Y&key=%@",
                                       self.beerStyle.styleId,
                                       BREWERY_DB_API_KEY
                                       ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request
                                                                                      responseDescriptors:@[responseDescriptor]];
    
    RKManagedObjectStore *store = [[BeerInfoDataModel sharedDataModel] objectStore];
    operation.managedObjectCache = store.managedObjectCache;
    operation.managedObjectContext = store.mainQueueManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.beers = mappingResult.array;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Request failed"];
    }];
    
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"beerCell";
    BeerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Beer *beer = [self.beers objectAtIndex:indexPath.row];

    [self configureCell:cell withBeer:beer];
    return cell;
}

- (void)configureCell:(BeerCell *)cell withBeer:(Beer *)beer {
    cell.nameLabel.text = beer.name;
    
    if ([beer.brewery length] > 0) {
        cell.breweryLabel.text = beer.brewery;
    } else {
        cell.breweryLabel.text = @"";
    }
    
    if ([beer.ibu length] > 0) {
        cell.ibuLabel.text = [NSString stringWithFormat:@"%@ IBUs", beer.ibu];
    } else {
        cell.ibuLabel.text = @"";
    }
    
    if ([beer.abv length] > 0) {
        cell.abvLabel.text = [NSString stringWithFormat:@"%@%% ABV", beer.abv];
    } else {
        cell.abvLabel.text = @"";
    }
    
    NSURL *imageUrl = [NSURL URLWithString:beer.labelIconImageUrl];
    UIImage *defaultImage = [UIImage imageNamed:@"beer-icon.png"];
    
    if (imageUrl) {
        [cell.labelImageView setImageWithURL:imageUrl
                            placeholderImage:defaultImage];
    } else {
        cell.labelImageView.image = defaultImage;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
