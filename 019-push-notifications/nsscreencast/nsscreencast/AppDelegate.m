//
//  AppDelegate.m
//  nsscreencast
//
//  Created by Ben Scheirman on 5/20/12.
//  Copyright (c) 2012 Fickle Bits, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    
    RootViewController *rvc = [[RootViewController alloc] initWithNibName:@"RootViewController"
                                                                   bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.window.rootViewController = navc;
    
    [application registerForRemoteNotificationTypes:(
                                                     UIRemoteNotificationTypeAlert | 
                                                     UIRemoteNotificationTypeBadge 
                                                     )];
    
    NSLog(@"launch options: %@", launchOptions);
    [application setApplicationIconBadgeNumber:0];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device token: %@", deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@", [deviceToken description]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"token string: %@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Remote notification received: %@", userInfo);
}

@end
