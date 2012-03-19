//
//  Beer.h
//  BeerScroller
//
//  Created by Ben Scheirman on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beer : NSObject

@property (nonatomic) NSInteger beerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brewery;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
