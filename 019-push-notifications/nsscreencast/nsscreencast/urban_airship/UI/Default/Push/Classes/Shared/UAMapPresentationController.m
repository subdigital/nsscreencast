/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "UAMapPresentationController.h"
#import "UAGlobal.h"
#import "UALocationDemoAnnotation.h"
#import "UALocationService.h"
#import "UAGlobal.h"

@implementation UAMapPresentationController
@synthesize locationService = locationService_;
@synthesize locations = locations_;
@synthesize mapView = mapView_;
@synthesize annotations = annotations_;
@synthesize rightButton = rightButton_;
@synthesize lastUserAnnotation = lastUserAnnotation_;

#pragma mark -
#pragma mark Memory

- (void) dealloc {
    RELEASE_SAFELY(locationService_);
    RELEASE_SAFELY(locations_);
    RELEASE_SAFELY(annotations_);
    RELEASE_SAFELY(lastUserAnnotation_);
    [super dealloc];
}


#pragma mark -
#pragma mark View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!locations_) {
        self.locations = [NSMutableArray array];
    }
    UALOG(@"LOCATIONS ARRAY %@", locations_);
    self.annotations = [NSMutableArray array];
    [self convertLocationsToAnnotations];
    self.navigationItem.rightBarButtonItem = rightButton_;
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.rightButton = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    mapView_.delegate = nil; // delegate is set in xib
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Class Methods

- (void)moveSpanToCoordinate:(CLLocationCoordinate2D)location {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [mapView_ setRegion:region animated:NO  ];
}

- (void)convertLocationsToAnnotations {
    for (CLLocation* location in locations_) {
        UALocationDemoAnnotation *annotation = [UALocationDemoAnnotation locationAnnotationFromLocation:location];
        [annotations_ addObject:annotation];
    }
    UALOG(@"ANNOTATIONS %@", annotations_);
}

- (void)annotateMap {
    UALOG(@"annotateMap");
    [mapView_ addAnnotations:annotations_];
    rightButton_.title = @"-Pin";
}

- (IBAction)rightBarButtonPressed:(id)sender {
    UALOG(@"Right bar button pressed");
    // The Map                   
    if ([[mapView_ annotations] count] > 1) {
        UALOG(@"Removing annotations");
        [mapView_ removeAnnotations:annotations_];
        rightButton_.title = @"+Pin";
    }
    else {
        UALOG(@"Adding annotations");
        [self annotateMap];
    }
}


#pragma mark -
#pragma mark MKMapViewDelegate 

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    UALOG(@"didChangeUserTrackingMode");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    // Return nil for the MKUserLocation object
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        self.lastUserAnnotation = annotation;
        UALOG(@"Returning nil for MKUserLocation Lat:%f Long:%f", annotation.coordinate.latitude, annotation.coordinate.longitude);
        return nil;
    }
    UALOG(@"Creating view for annotation %@", annotation);
    
    if (!annotation) {
        UALOG(@"ANNOTATION IS NIL!!!!");
    }
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.animatesDrop = YES;
    return [pinView autorelease];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    UALOG(@"Annotations added to map %@", views);
    if ([views count] > 0) {
       MKAnnotationView *view = [views objectAtIndex:0];
        CLLocationCoordinate2D coord = view.annotation.coordinate;
        [self moveSpanToCoordinate:coord];
    }
}

@end
