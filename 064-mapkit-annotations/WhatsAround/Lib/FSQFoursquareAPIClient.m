//
//  FKLFoursquareAPIClient.m
//  WhatsAround
//
//  Created by ben on 4/22/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "FSQFoursquareAPIClient.h"

#define FOURSQUARE_BASE_URL @"https://api.foursquare.com/v2/"

@implementation FSQFoursquareAPIClient

+ (FSQFoursquareAPIClient *)sharedClient {
    static FSQFoursquareAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:FOURSQUARE_BASE_URL];
        _sharedClient = [[FSQFoursquareAPIClient alloc] initWithBaseURL:baseUrl];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void)fetchVenuesNear:(CLLocationCoordinate2D)coordinates
             searchTerm:(NSString *)searchTerm
         radiusInMeters:(CGFloat)radius
             completion:(FSQVenuesBlock)completion {
    id params = @{
                  @"ll" : [self latLongValueForCoordinate:coordinates],
                  @"radius" : @(radius),
                  @"query" : searchTerm,
                  @"intent" : @"browse"
                };
    [self getPath:@"venues/search"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *venues = [self venuesForResponse:responseObject[@"response"][@"venues"]];
              completion(venues, nil);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Response status code: %d", operation.response.statusCode);
              NSLog(@"Response body: %@", operation.responseString);
              NSLog(@"ERROR: %@", error);
              completion(nil, error);
          }];
}

- (NSArray *)venuesForResponse:(NSArray *)venueDictionaries {
    NSMutableArray *venues = [NSMutableArray arrayWithCapacity:[venueDictionaries count]];
    for (id venueDictionary in venueDictionaries) {
        [venues addObject:[FSQVenue venueWithDictionary:venueDictionary]];
    }
    return venues;
}

- (NSString *)latLongValueForCoordinate:(CLLocationCoordinate2D)coord {
    return [NSString stringWithFormat:@"%g,%g", coord.latitude, coord.longitude];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setObject:FOURSQUARE_APP_CLIENT_ID forKey:@"client_id"];
    [params setObject:FOURSQUARE_APP_CLIENT_SECRET forKey:@"client_secret"];
    
    // versioning parameter, expected to contain the hard coded date the API was verified.
    // This is per Foursquare's API guide.  Must be in YYYYMMDD format.
    [params setObject:@"20130420" forKey:@"v"];
    
    return [super requestWithMethod:method path:path parameters:params];
}

@end
