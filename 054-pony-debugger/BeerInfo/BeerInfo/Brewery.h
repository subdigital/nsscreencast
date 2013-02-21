//
//  Brewery.h
//  BeerInfo
//
//  Created by ben on 1/27/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Brewery : NSManagedObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *website;

@end
