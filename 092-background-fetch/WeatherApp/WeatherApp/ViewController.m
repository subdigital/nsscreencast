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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onBackgroundUpdate:)
                                                 name:@"WeatherUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)onActive:(NSNotification *)notification {
    [self loadFromCache];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadFromCache];
}

- (void)loadFromCache {
    WeatherResult *cachedResult = [[WeatherFetcher sharedInstance] cachedResult];
    
    if (cachedResult) {
        self.searchBar.text = cachedResult.location;
        [self updateTemperature:cachedResult.temperature
                    lastUpdated:cachedResult.updatedAt];
        
        if ([self needsRefresh:cachedResult.updatedAt] && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            [self searchForLocation:cachedResult.location];
        }
    }
}

- (BOOL)needsRefresh:(NSDate *)lastUpdated {
    NSTimeInterval interval = abs([lastUpdated timeIntervalSinceNow]);
    return abs(interval) > 15;
}

- (void)updateTemperature:(CGFloat)temp lastUpdated:(NSDate *)updatedAt {
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.1fºF", temp];
    self.updatedLabel.text = [NSString stringWithFormat:@"Last updated at %@", updatedAt];
}

- (void)searchForLocation:(NSString *)location {
    [self.activityIndicatorView startAnimating];
    
    [[WeatherFetcher sharedInstance] fetchWeatherForLocation:location completion:^(WeatherResult *result) {
        [self.activityIndicatorView stopAnimating];
        [self updateTemperature:result.temperature
                    lastUpdated:result.updatedAt];
    }];
}

- (void)onBackgroundUpdate:(NSNotification *)notification {
    WeatherResult *result = [notification object];
    [self updateTemperature:result.temperature
                lastUpdated:result.updatedAt];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchForLocation:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
