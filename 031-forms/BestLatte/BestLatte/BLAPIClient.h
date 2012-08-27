//
//  BLAPIClient.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFNetworking.h"

@interface BLAPIClient : AFHTTPClient

+ (id)sharedClient;

@end
