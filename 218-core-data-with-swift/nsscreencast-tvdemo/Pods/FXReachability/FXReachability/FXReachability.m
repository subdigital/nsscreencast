//
//  FXReachability.m
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

#import "FXReachability.h"
#import <Availability.h>


#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


NSString *const FXReachabilityStatusDidChangeNotification = @"FXReachabilityStatusDidChangeNotification";
NSString *const FXReachabilityNotificationStatusKey = @"status";
NSString *const FXReachabilityNotificationPreviousStatusKey = @"previousStatus";
NSString *const FXReachabilityNotificationHostKey = @"host";


@interface FXReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachability;
@property (nonatomic, assign) FXReachabilityStatus status;

@end


@implementation FXReachability

static void FXReachabilityCallback(__unused SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
    FXReachability *self = (__bridge id)info;
    FXReachabilityStatus status = FXReachabilityStatusUnknown;
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0 ||
        (flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0)
    {
        status = FXReachabilityStatusNotReachable;
    }
    
#if	TARGET_OS_IPHONE
    
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0)
    {
        status = FXReachabilityStatusReachableViaWWAN;
    }
    
#endif
    
    else
    {
        status = FXReachabilityStatusReachableViaWiFi;
    }
    
    if (status != self.status)
    {
        FXReachabilityStatus previousStatus = self.status;
        self.status = status;

        NSDictionary *userInfo = @{FXReachabilityNotificationStatusKey: @(status), FXReachabilityNotificationPreviousStatusKey: @(previousStatus), FXReachabilityNotificationHostKey: self.host};
        [[NSNotificationCenter defaultCenter] postNotificationName:FXReachabilityStatusDidChangeNotification object:self userInfo:userInfo];
    }
}

+ (void)load
{
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)sharedInstance
{
    static FXReachability *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (BOOL)isReachable
{
    return self.status != FXReachabilityStatusNotReachable;
}

+ (BOOL)isReachable
{
    return [[self sharedInstance] isReachable];
}

- (instancetype)initWithHost:(NSString *)hostDomain
{
    if ((self = [super init]))
    {
        self.host = hostDomain;
    }
    return self;
}

- (void)setHost:(NSString *)host
{
    if (host != _host)
    {
        if (_reachability)
        {
            SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
            CFRelease(_reachability);
        }
        _host = [host copy];
        _status = FXReachabilityStatusUnknown;
        _reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [_host UTF8String]);
        SCNetworkReachabilityContext context = { 0, ( __bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(_reachability, FXReachabilityCallback, &context);
        SCNetworkReachabilityScheduleWithRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
}

- (instancetype)init
{
    return [self initWithHost:@"apple.com"];
}

- (void)dealloc
{
    if (_reachability)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(_reachability);
    }
}

@end
