//
//  BeerStyle.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerStyle : NSObject

@property (nonatomic, assign) NSInteger styleId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *styleDescription;
@property (nonatomic, copy) NSString *category;

@end
