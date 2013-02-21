//
//  MappingProvider.h
//  BeerInfo
//
//  Created by ben on 1/29/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvider : NSObject

+ (RKMapping *)beerStyleMapping;
+ (RKMapping *)beerMapping;
+ (RKMapping *)breweryMapping;

@end
