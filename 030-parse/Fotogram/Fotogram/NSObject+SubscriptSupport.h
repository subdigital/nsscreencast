//
//  NSObject+SubscriptSupport.h
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>


// Provides support for NSArray & NSDictionary subscripting, until official iOS SDK support comes out in Xcode 4.5.
// http://stackoverflow.com/questions/11658669/how-to-enable-the-new-objective-c-object-literals-on-ios

@interface NSObject (SubscriptSupport)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
