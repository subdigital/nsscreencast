//
//  TVShowSearchViewController.m
//  TuneStore
//
//  Created by ben on 9/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "MediaSearchViewController.h"
#import "MediaCell.h"

@interface MediaSearchViewController ()

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MediaSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfig];
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
    
    return cell;
}

- (void)clearResults {
    self.results = nil;
    [self.tableView reloadData];
}

- (void)handleSearchResults:(NSData *)data {
    NSError *jsonError;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
    if (response) {
        self.results = response[@"results"];
        [self.tableView reloadData];
    } else {
        NSLog(@"ERROR: %@", jsonError);
    }
}

- (void)searchForTerm:(NSString *)term {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self clearResults];
    
    NSString *termEncoded = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?country=US&term=%@", termEncoded];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                     if (httpResponse.statusCode == 200) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self handleSearchResults:data];
                                                         });
                                                     } else {
                                                         NSString *body = [[NSString alloc] initWithData:data
                                                                                                encoding:NSUTF8StringEncoding];
                                                         NSLog(@"Received HTTP %d:  %@", httpResponse.statusCode, body);
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                         message:@"Received an error from the server"
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"OK"
                                                                               otherButtonTitles:nil] show];
                                                         });
                                                     }
                                                 }];
    [task resume];
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
