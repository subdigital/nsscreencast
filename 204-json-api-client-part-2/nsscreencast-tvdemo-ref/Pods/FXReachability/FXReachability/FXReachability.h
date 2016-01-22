//
//  FXReachability.h
//
//  Version 1.3.1
//
//  Created by Nick Lockwood on 13/04/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXReachability
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


extern NSString *const FXReachabilityStatusDidChangeNotification;
extern NSString *const FXReachabilityNotificationStatusKey;
extern NSString *const FXReachabilityNotificationPreviousStatusKey;
extern NSString *const FXReachabilityNotificationHostKey;


typedef NS_ENUM(NSInteger, FXReachabilityStatus)
{
    FXReachabilityStatusUnknown  = -1,
    FXReachabilityStatusNotReachable = 0,
    FXReachabilityStatusReachableViaWWAN = 1,
    FXReachabilityStatusReachableViaWiFi = 2,
};


@interface FXReachability : NSObject

@property (nonatomic, readonly) FXReachabilityStatus status;
@property (nonatomic, copy) NSString *host;

+ (instancetype)sharedInstance;
+ (BOOL)isReachable;

- (instancetype)initWithHost:(NSString *)hostDomain NS_DESIGNATED_INITIALIZER;
- (BOOL)isReachable;

@end


#pragma GCC diagnostic pop
