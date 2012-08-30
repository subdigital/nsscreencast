//
//  NSDictionary+JSONValueParsing.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/28/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONValueParsing)

- (int)intForKey:(id)key;
- (NSString *)stringForKey:(id)key;

@end
