//
//  Car.h
//  RealmDemo
//
//  Created by Ben Scheirman on 8/10/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Realm/Realm.h>
#import "OilChange.h"

RLM_ARRAY_TYPE(OilChange)

@interface Car : RLMObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic) NSInteger year;
@property (nonatomic, strong) RLMArray<OilChange> *oilChanges;

@end
