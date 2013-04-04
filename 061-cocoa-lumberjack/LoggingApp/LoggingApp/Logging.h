//
//  Logging.h
//  LoggingApp
//
//  Created by ben on 4/1/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "DDLog.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define NSLog DDLogInfo