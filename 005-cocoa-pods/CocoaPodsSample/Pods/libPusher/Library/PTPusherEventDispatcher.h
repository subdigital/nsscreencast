//
//  PTPusherEventDispatcher.h
//  libPusher
//
//  Created by Luke Redpath on 13/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTEventListener.h"

@interface PTPusherEventDispatcher : NSObject <PTEventListener> {
  NSMutableDictionary *eventListeners;
}

- (void)addEventListener:(id<PTEventListener>)listener forEventNamed:(NSString *)eventName;
@end
