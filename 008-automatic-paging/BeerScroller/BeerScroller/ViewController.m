//
//  ViewController.m
//  BeerScroller
//
//  Created by Ben Scheirman on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Beer.h"

const int kLoadingCellTag = 1273;

@interface ViewController ()
@property (nonatomic, retain) NSMutableArray *beers;
- (void)fetchBeers;
@end

@implementation ViewController

@synthesize beers = _beers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beers = [NSMutableArray array];
    _currentPage = 0;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [_beers release];
    
    [super dealloc];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentPage == 0) {
        return 1;
    }
    
    if (_currentPage < _totalPages) {
        return self.beers.count + 1;
    }
    return self.beers.count;
}

- (UITableViewCell *)beerCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    Beer *beer = [self.beers objectAtIndex:indexPath.row];
    cell.textLabel.text = beer.name;
    cell.detailTextLabel.text = beer.brewery;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil] autorelease];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] 
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator release];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.beers.count) {
        return [self beerCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        _currentPage++;
        [self fetchBeers];
    }
}

#pragma mark - fetching

- (void)fetchBeers {
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:3000/beers.json?page=%d", _currentPage];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@", responseObject);
        
        _totalPages = [[responseObject objectForKey:@"total_pages"] intValue];
        
        for (id beerDictionary in [responseObject objectForKey:@"beers"]) {
            Beer *beer = [[Beer alloc] initWithDictionary:beerDictionary];
            if (![self.beers containsObject:beer]) {
                [self.beers addObject:beer];                
            }

            [beer release];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [[[[UIAlertView alloc] initWithTitle:@"Error fetching beers!"
                                     message:@"Please try again later"
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
    }];
    
    [operation start];
    [operation release];
}

@end
