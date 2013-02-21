//
//  BeersAPIClient.h
//  BeerInfo
//
//  Created by ben on 2/5/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "AFHTTPClient.h"

@interface BeersAPIClient : AFHTTPClient

+ (BeersAPIClient *)sharedClient;
    
@end
