//
//  ViewController.m
//  WeatherApp
//
//  Created by ben on 10/20/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"
#import "WeatherFetcher.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateTemperature:(CGFloat)temp lastUpdated:(NSDate *)updatedAt {
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.1fºF", temp];
    self.updatedLabel.text = [NSString stringWithFormat:@"Last updated at %@", updatedAt];
}

- (void)searchForLocation:(NSString *)location {
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchForLocation:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
