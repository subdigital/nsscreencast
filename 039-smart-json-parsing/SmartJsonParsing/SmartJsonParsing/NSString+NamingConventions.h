//
//  NSString+NamingConventions.h
//  SmartJsonParsing
//
//  Created by Ben Scheirman on 10/22/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NamingConventions)

+ (NSString *)camelCase:(NSArray *)components;

@end
