//
//  TVShowSearchViewController.m
//  TuneStore
//
//  Created by ben on 9/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "MediaSearchViewController.h"
#import "MediaCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "ITunesClient.h"

@interface MediaSearchViewController ()

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation MediaSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"mediaCell";
    MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *record = self.results[indexPath.row];
    
    cell.nameLabel.text = record[@"artistName"];
    cell.descriptionLabel.text = record[@"primaryGenreName"];
    cell.collectionNameLabel.text = record[@"collectionName"];
    
    cell.artworkImageView.image = nil;
    [cell.artworkImageView cancelImageRequestOperation];

    NSURL *imageURL = [NSURL URLWithString:record[@"artworkUrl100"]];
    if (imageURL) {
        [cell.artworkImageView setImageWithURL:imageURL];
    }
    
    return cell;
}

- (void)clearResults {
    self.results = nil;
    [self.tableView reloadData];
}

- (void)searchForTerm:(NSString *)term {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self clearResults];
 
    NSURLSessionDataTask *task = [[ITunesClient sharedClient] searchForTerm:term
                                                                 completion:^(NSArray *results, NSError *error) {
                                                                     if (results) {
                                                                         self.results = results;
                                                                         [self.tableView reloadData];
                                                                     } else {
                                                                         NSLog(@"ERROR: %@", error);
                                                                     }
                                                                 }];
    
    [self.indicator setAnimatingWithStateOfTask:task];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchForTerm:searchBar.text];
}

@end
