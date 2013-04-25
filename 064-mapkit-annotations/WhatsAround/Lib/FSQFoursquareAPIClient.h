//
//  FKLFoursquareAPIClient.h
//  WhatsAround
//
//  Created by ben on 4/22/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//


#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "FSQVenue.h"


#ifndef FOURSQUARE_APP_CLIENT_ID
#warning Please define FOURSQUARE_APP_CLIENT_ID somewhere
#endif
#ifndef FOURSQUARE_APP_CLIENT_SECRET
#warning Please define FOURSQUARE_APP_CLIENT_SECRET somewhere
#endif

typedef void (^FSQVenuesBlock)(NSArray *venues, NSError *error);

@interface FSQFoursquareAPIClient : AFHTTPClient

+ (FSQFoursquareAPIClient *)sharedClient;

- (void)fetchVenuesNear:(CLLocationCoordinate2D)coordinates
             searchTerm:(NSString *)searchTerm
         radiusInMeters:(CGFloat)radius
             completion:(FSQVenuesBlock)completion;
    
@end
