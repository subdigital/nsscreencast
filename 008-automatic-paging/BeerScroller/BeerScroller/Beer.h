//
//  Beer.h
//  BeerScroller
//
//  Created by Ben Scheirman on 3/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beer : NSObject

@property (nonatomic, assign) NSInteger beerId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brewery;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
