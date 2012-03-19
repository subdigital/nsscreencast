//
//  ViewController.m
//  BeerScroller
//
//  Created by Ben Scheirman on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Beer.h"

const int kLoadingCellTag = 1321;

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *beers;
- (void)fetchBeers;
@end

@implementation ViewController

@synthesize beers = _beers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Beer!";
    
    self.beers = [NSMutableArray array];
    
    _currentPage = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UITableViewDataSource methods

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
    static NSString *cellId = @"beerCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor colorWithRed:0.1 green:0.16 blue:0.27 alpha:1.0];
    }
    
    Beer *beer = [self.beers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = beer.name;
    cell.detailTextLabel.text = beer.brewery;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = loadingCell.center;
    [loadingCell addSubview:indicator];
    [indicator startAnimating];    
    loadingCell.tag = kLoadingCellTag;
    return loadingCell;
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"1234abcd" forHTTPHeaderField:@"x-api-token"];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        double delayInSeconds = 1.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Received: %@", responseObject);
                _totalPages = [[responseObject objectForKey:@"total_pages"] intValue];
                for (id beerDictionary in [responseObject objectForKey:@"beers"]) {
                    Beer *beer = [[Beer alloc] initWithDictionary:beerDictionary];
                    
                    if (![self.beers containsObject:beer]) {
                        [self.beers addObject:beer];                        
                    }

                }
                [self.tableView reloadData]; 
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error!  %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Received an error from the server.  Please try again later." 
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }];
    
    [operation start];
}

@end
