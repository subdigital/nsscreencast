//
//  WARMapViewController.m
//  WhatsAround
//
//  Created by ben on 4/16/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "WARMapViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "WARAppDelegate.h"
#import "WARMapOverlay.h"
#import "WARMapOverlayView.h"

@interface WARMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *venues;

@end

@implementation WARMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
