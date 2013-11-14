//
//  ViewController.m
//  BeaconFun
//
//  Created by ben on 11/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BEACON_UUID @"05FA9520-775B-4133-B3C8-7E805807B7D6"

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:@"com.nsscreencast.beaconfun.region"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:region];
    
    [self.locationManager requestStateForRegion:region];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:@"com.nsscreencast.beaconfun.region"]) {
            
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
            
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:@"com.nsscreencast.beaconfun.region"]) {
            
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
            
        }
    }
}

- (NSString *)stringForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:    return @"Unknown";
        case CLProximityFar:        return @"Far";
        case CLProximityNear:       return @"Near";
        case CLProximityImmediate:  return @"Immediate";
        default:
            return nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSLog(@"Ranging beacon: %@", beacon.proximityUUID);
        NSLog(@"%@ - %@", beacon.major, beacon.minor);
        NSLog(@"Range: %@", [self stringForProximity:beacon.proximity]);
        
        [self setColorForProximity:beacon.proximity];
    }
}

- (void)setColorForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
            
        case CLProximityFar:
            self.view.backgroundColor = [UIColor yellowColor];
            break;
            
        case CLProximityNear:
            self.view.backgroundColor = [UIColor orangeColor];
            break;
            
        case CLProximityImmediate:
            self.view.backgroundColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
}

@end
