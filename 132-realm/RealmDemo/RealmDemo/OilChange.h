//
//  OilChange.h
//  RealmDemo
//
//  Created by Ben Scheirman on 8/10/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Realm/Realm.h>

@interface OilChange : RLMObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger mileage;

@end
