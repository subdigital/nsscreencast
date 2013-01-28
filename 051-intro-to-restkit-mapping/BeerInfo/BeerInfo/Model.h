//
//  Model.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol Model <NSObject>

+ (RKMapping *)mapping;

@end