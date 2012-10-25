//
//  JSONObject.h
//  SmartJsonParsing
//
//  Created by Ben Scheirman on 10/21/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONObject : NSObject

+ (id)objectWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)populateDictionary:(NSDictionary *)dictionary;
+ (NSString *)normalizedKey:(NSString *)inKey;
    
@end
