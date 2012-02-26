//
//  TestHelper.m
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"

@implementation LRBlockMatcher

- (id)initWithMatcherBlock:(BOOL (^)(id))block
{
  if ((self = [super init])) {
    matcherBlock = [block copy];
  }
  return self;
}

- (void)dealloc 
{
  [matcherBlock release];
  [super dealloc];
}

- (BOOL)matches:(id)object
{
  return matcherBlock(object);
}

- (void)describeTo:(id<HCDescription>)description
{

}

@end

id<HCMatcher> passesBlock(BOOL (^block)(id))
{
  return [[[LRBlockMatcher alloc] initWithMatcherBlock:block] autorelease];
}
