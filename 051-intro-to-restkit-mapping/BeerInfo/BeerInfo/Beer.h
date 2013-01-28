//
//  Beer.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Beer : NSObject <Model>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ibu;
@property (nonatomic, copy) NSString *abv;
@property (nonatomic, readonly) NSString *brewery;
@property (nonatomic, copy) NSString *labelIconImageUrl;
@property (nonatomic, strong) NSArray *breweries;

@end
