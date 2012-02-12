//
//  ViewController.m
//  TableViewBasics
//
//  Created by Ben Scheirman on 2/12/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize beers = _beers;

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadBeers {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beers" ofType:@"plist"];
    self.beers = [NSArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBeers];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDatasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:nil] autorelease];
        cell.textLabel.textColor = [UIColor colorWithRed:0.6f green:0.7f blue:0.8f alpha:1.0f];
    }
    
    NSDictionary *beerInfo = [self.beers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [beerInfo objectForKey:@"name"];
    cell.detailTextLabel.text = [beerInfo objectForKey:@"type"];
    
    UIImage *image = [UIImage imageNamed:[beerInfo objectForKey:@"image"]];
    cell.imageView.image = image;
    
    return cell;
}


@end
