//
//  BeerStyle.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BeerStyle : NSObject

@property (nonatomic, strong) NSNumber *styleId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *styleDescription;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSArray *beers;

@end
