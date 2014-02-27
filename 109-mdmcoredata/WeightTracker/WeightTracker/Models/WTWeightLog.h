//
//  WTWeightLog.h
//  WeightTracker
//
//  Created by ben on 2/25/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WTWeightLog : NSManagedObject

@property (nonatomic, strong) NSDate * dateTaken;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSString * units;

@end
