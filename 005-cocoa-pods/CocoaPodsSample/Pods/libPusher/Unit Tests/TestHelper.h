//
//  TestHelper.h
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCHamcrest/HCBaseMatcher.h>

#define LRMOCKY_SUGAR
#import "LRMocky.h"

@interface LRBlockMatcher : HCBaseMatcher {
  BOOL (^matcherBlock)(id);
}
- (id)initWithMatcherBlock:(BOOL (^)(id))block;
@end

id<HCMatcher> passesBlock(BOOL (^block)(id));
