//
//  AppDelegate.m
//  RealmDemo
//
//  Created by Ben Scheirman on 8/10/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RLMRealm *realm = [RLMRealm defaultRealm];
  
  NSLog(@"--- begin transaction");
  [realm beginWriteTransaction];
  
  [realm deleteObjects:[Car allObjects]];
  [realm deleteObjects:[OilChange allObjects]];
  
  Car *car = [Car new];
  car.name = @"Honda Civic";
  car.year = 1998;
  car.color = @"Black";
  [realm addObject:car];
  
  const NSInteger SecondsInAMonth = 60 * 60 * 24 * 30;
  NSDate *lastDate = [NSDate date];
  int mileage = 0;
  for (int d = 48; d >= 0; d--) {
    NSDate *date = [lastDate dateByAddingTimeInterval:- d * SecondsInAMonth];
    lastDate = date;
    mileage += 3000;
    OilChange *change = [OilChange new];
    change.date = date;
    change.mileage = mileage;
    [car.oilChanges addObject:change];
  }
  
  Car *car2 = [Car new];
  car2.name = @"BMW M5";
  car2.year = 2010;
  car2.color = @"White";
  [realm addObject:car2];
  
  [realm commitWriteTransaction];
  NSLog(@"--- commit transaction");
  
  RLMArray *cars = [Car allObjectsInRealm:realm];
  NSLog(@"Found: %@", cars);
  
  NSLog(@"Cars staring with B: %@",
        [Car objectsWhere:@"name beginswith 'B'"]
        );
  
  NSLog(@"Oil changes since 100k miles: %@",
        [OilChange objectsWhere:@"mileage > 100000"]
        );
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
