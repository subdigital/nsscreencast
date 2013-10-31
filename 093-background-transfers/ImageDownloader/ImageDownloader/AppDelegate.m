//
//  AppDelegate.m
//  ImageDownloader
//
//  Created by ben on 10/28/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)application:(UIApplication *)application
handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
  
    NSDictionary *userInfo = @{@"sessionIdentifier": identifier,
                               @"completionHandler": completionHandler};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackgroundSessionUpdated"
                                                        object:nil
                                                      userInfo:userInfo];
}

@end
