//
//  BeersAPIClient.h
//  PinningDemo
//
//  Created by ben on 6/23/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#define _AFNETWORKING_PIN_SSL_CERTIFICATES_

#import "AFNetworking.h"
#import "AFHTTPClient.h"

@interface BeersAPIClient : AFHTTPClient

+ (BeersAPIClient *)sharedClient;

@end
