//
//  NSCRAppDelegate.m
//  nsscreencast
//
//  Created by Ben Scheirman on 6/11/12.
//  Copyright (c) 2012 Ben Scheirman. All rights reserved.
//

#import "NSCRAppDelegate.h"

@implementation NSCRAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
