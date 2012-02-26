//
//  AardvarkSpec.m
//  libPusher
//
//  Created by Luke Redpath on 25/01/2012.
//  Copyright 2012 LJR Software Limited. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(AardvarkSpec)

describe(@"AardvarkSpec", ^{
  
  it(@"should work", ^{
    [[@"foo" should] equal:@"foo"];
	});
  
});

SPEC_END
