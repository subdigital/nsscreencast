//
//  AppDelegate.m
//  SearchStore
//
//  Created by Ben Scheirman on 9/30/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "Product.h"
#import "Category.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    masterViewController.managedObjectContext = self.managedObjectContext;
    self.window.rootViewController = self.navigationController;
    
    [self setupTestProducts];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (int)numberOfProducts {
    return [Product productCountWithManagedObjectContext:[self managedObjectContext]];
}

- (void)setupTestProducts {
    if ([self numberOfProducts] == 0) {
        Category *electronics = [Category insertInManagedObjectContext:[self managedObjectContext]];
        electronics.name = @"Electronics";
        
        Product *xbox = [Product insertInManagedObjectContext:[self managedObjectContext]];
        xbox.name = @"Xbox 360";
        xbox.price = [NSDecimalNumber decimalNumberWithString:@"204.99"];
        xbox.category = electronics;
        
        Product *playstation = [Product insertInManagedObjectContext:[self managedObjectContext]];
        playstation.name = @"Playstation 3";
        playstation.price = [NSDecimalNumber decimalNumberWithString:@"249.00"];
        playstation.category = electronics;
        
        Product *camera = [Product insertInManagedObjectContext:[self managedObjectContext]];
        camera.name = @"Canon 5D";
        camera.price = [NSDecimalNumber decimalNumberWithString:@"1799.00"];
        camera.category = electronics;
        
        Category *books = [Category insertInManagedObjectContext:[self managedObjectContext]];
        books.name = @"Books";
        
        Product *harryPotter = [Product insertInManagedObjectContext:[self managedObjectContext]];
        harryPotter.name = @"Harry Potter and the Sorceror's Stone";
        harryPotter.price = [NSDecimalNumber decimalNumberWithString:@"8.99"];
        harryPotter.category = books;
        
        Product *harryPotter2 = [Product insertInManagedObjectContext:[self managedObjectContext]];
        harryPotter2.name = @"Harry Potter and the Chamber of Secrets";
        harryPotter2.price = [NSDecimalNumber decimalNumberWithString:@"8.99"];
        harryPotter2.category = books;
        
        Product *harryPotter3 = [Product insertInManagedObjectContext:[self managedObjectContext]];
        harryPotter3.name = @"Harry Potter and the Prisoner of Azkaban";
        harryPotter3.price = [NSDecimalNumber decimalNumberWithString:@"8.99"];
        harryPotter3.category = books;
        
        Product *harryPotter4 = [Product insertInManagedObjectContext:[self managedObjectContext]];
        harryPotter4.name = @"Harry Potter and the Goblet of Fire";
        harryPotter4.price = [NSDecimalNumber decimalNumberWithString:@"9.99"];
        harryPotter4.category = books;
        
        Category *movies = [Category insertInManagedObjectContext:[self managedObjectContext]];
        movies.name = @"Movies";
        
        Product *inception = [Product insertInManagedObjectContext:[self managedObjectContext]];
        inception.name = @"Inception (Blu-Ray)";
        inception.price = [NSDecimalNumber decimalNumberWithString:@"14.99"];
        inception.category = movies;
        
        Product *avengers = [Product insertInManagedObjectContext:[self managedObjectContext]];
        avengers.name = @"Avengers (Blu-Ray)";
        avengers.price = [NSDecimalNumber decimalNumberWithString:@"19.99"];
        avengers.category = movies;
        
        Product *reservoirDogs = [Product insertInManagedObjectContext:[self managedObjectContext]];
        reservoirDogs.name = @"Reservoir Dogs (DVD)";
        reservoirDogs.price = [NSDecimalNumber decimalNumberWithString:@"9.99"];
        reservoirDogs.category = movies;
        
        Product *bigLebowski = [Product insertInManagedObjectContext:[self managedObjectContext]];
        bigLebowski.name = @"The Big Lebowski (Blu-Ray)";
        bigLebowski.price = [NSDecimalNumber decimalNumberWithString:@"11.99"];
        bigLebowski.category = movies;
        
        Product *memento = [Product insertInManagedObjectContext:[self managedObjectContext]];
        memento.name = @"Memento (DVD)";
        memento.price = [NSDecimalNumber decimalNumberWithString:@"14.99"];
        memento.category = movies;

        Product *amelie = [Product insertInManagedObjectContext:[self managedObjectContext]];
        amelie.name = @"Amélie (DVD)";
        amelie.price = [NSDecimalNumber decimalNumberWithString:@"8.99"];
        amelie.category = movies;
        
        Product *swingers = [Product insertInManagedObjectContext:[self managedObjectContext]];
        swingers.name = @"Swingers (DVD)";
        swingers.price = [NSDecimalNumber decimalNumberWithString:@"4.99"];
        swingers.category = movies;
        
        Product *labyrinth = [Product insertInManagedObjectContext:[self managedObjectContext]];
        labyrinth.name = @"Labyrinth (DVD)";
        labyrinth.price = [NSDecimalNumber decimalNumberWithString:@"4.99"];
        labyrinth.category = movies;
        
        NSError *error = nil;
        if ([[self managedObjectContext] save:&error]) {
            NSLog(@"Created test records");
        } else {
            [NSException raise:NSGenericException format:@"Couldn't insert test records: %@", error];
        }
    }
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SearchStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SearchStore.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
