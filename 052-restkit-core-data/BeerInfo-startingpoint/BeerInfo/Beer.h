//
//  Beer.h
//  BeerInfo
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeerStyle, Brewery;

@interface Beer : NSObject

@property (nonatomic, strong) NSString *abv;
@property (nonatomic, strong) NSString *ibu;
@property (nonatomic, strong) NSString *labelIconImageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *breweries;
@property (nonatomic, strong) BeerStyle *style;

@property (nonatomic, readonly) NSString *brewery;

@end
