//
//  BeersViewController.m
//  PinningDemo
//
//  Created by ben on 6/23/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "BeersViewController.h"
#import "BeersAPIClient.h"

@interface BeersViewController ()
@property (nonatomic, strong) NSArray *beers;
@end

@implementation BeersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Beers";
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadBeers)
                  forControlEvents:UIControlEventValueChanged];

    [self loadBeers];
}

- (void)loadBeers {
    [self startLoading];
    
    [NSURLCache setSharedURLCache:nil];
    [[BeersAPIClient sharedClient] getPath:@"beers.json"
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self stopLoading];
                                       NSMutableArray *beers = [NSMutableArray array];
                                       for (NSDictionary *beerDictionary in responseObject[@"beers"]) {
                                           [beers addObject:beerDictionary[@"name"]];
                                       }
                                       self.beers = beers;
                                       [self.tableView reloadData];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [self stopLoading];
                                       NSLog(@"ERROR: %@", error);
                                       [[[UIAlertView alloc] initWithTitle:@"Can't fetch beers"
                                                                   message:[error localizedDescription]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil] show];
                                   }];
}

- (void)startLoading {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopLoading {
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *beer = self.beers[indexPath.row];
    cell.textLabel.text = beer;
}

@end
