//
//  ViewController.m
//  BeerList
//
//  Created by Ben Scheirman on 2/26/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "BeersApiClient.h"
#import "Beer.h"

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.90 alpha:1.0];    

    
    [[BeersApiClient sharedInstance] getPath:@"beers.json" parameters:nil 
                                     success:^(AFHTTPRequestOperation *operation, id response) {
                                         NSLog(@"Response: %@", response);
                                         NSMutableArray *results = [NSMutableArray array];
                                         for (id beerDictionary in response) {
                                             Beer *beer = [[Beer alloc] initWithDictionary:beerDictionary];
                                             [results addObject:beer];
                                             [beer release];
                                         }
                                         self.results = results;
                                         [self.tableView reloadData];
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Error fetching beers!");
                                         NSLog(@"%@", error);
                                         
                                     }];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];    
}

#pragma UITableViewDelegate / UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
        cell.detailTextLabel.backgroundColor = cell.textLabel.backgroundColor;
    }
    
    Beer *beer = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = beer.name;
    cell.detailTextLabel.text = beer.brewery;
    
    return cell;
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
