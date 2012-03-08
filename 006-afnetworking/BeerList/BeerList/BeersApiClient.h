//
//  BeersApiClient.h
//  BeerList
//
//  Created by Ben Scheirman on 2/26/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface BeersApiClient : AFHTTPClient

+ (id)sharedInstance;

@end
