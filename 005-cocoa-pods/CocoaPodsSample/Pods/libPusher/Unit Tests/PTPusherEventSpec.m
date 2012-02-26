//
//  PTPusherEventSpec.m
//  libPusher
//
//  Created by Luke Redpath on 25/01/2012.
//  Copyright 2012 LJR Software Limited. All rights reserved.
//

#import "SpecHelper.h"
#import "PTPusherEvent.h"

SPEC_BEGIN(PTPusherEventSpec)

describe(@"Pusher Events", ^{
  
  context(@"with a JSON payload", ^{
    __block PTPusherEvent *event = [[PTPusherEvent alloc] 
          initWithEventName:@"test-event" 
                    channel:@"test-channel" 
                       data:@"{\"json\": \"it rocks\"}"];
    
    
    it(@"returns the deserialized JSON as a native object", ^{
	    [[event.data should] beKindOfClass:[NSDictionary class]];
      [[event.data should] haveValue:@"it rocks" forKey:@"json"];
    });
  });
  
  context(@"with a malformed/non-JSON payload", ^{
    __block PTPusherEvent *event = [[PTPusherEvent alloc] 
          initWithEventName:@"test-event" 
                    channel:@"test-channel" 
                       data:@"this is not JSON"];
    
    it(@"returns the raw unparsed data", ^{
      [[event.data should] equal:@"this is not JSON"];
    });
  });
  
  context(@"from an event message dictionary", ^{
    __block PTPusherEvent *event = [[PTPusherEvent eventFromMessageDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"event data", @"data", @"test-event", @"event", @"some-channel", @"channel", nil]] retain];
                                    
    it(@"returns it's name", ^{
	    [[event.name should] equal:@"test-event"];
    });
    
    it(@"returns it's channel", ^{
	    [[event.channel should] equal:@"some-channel"];
    });
    
    it(@"returns it's data", ^{
	    [[event.data should] equal:@"event data"];
    });
  });
          
});

SPEC_END
