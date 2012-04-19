//
//  NSDictionary+ObjectForKeyOrNil.h
//  BeerBrowser
//
//  Created by Ben Scheirman on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ObjectForKeyOrNil)

- (id)objectForKeyOrNil:(id)key;

@end
