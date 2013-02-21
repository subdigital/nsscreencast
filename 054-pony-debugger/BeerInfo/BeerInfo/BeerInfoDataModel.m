//
//  BeerInfoDataModel.m
//  BeerInfo
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import "BeerInfoDataModel.h"
#import <CoreData/CoreData.h>

@interface BeerInfoDataModel ()
@end

@implementation BeerInfoDataModel

+ (id)sharedDataModel {
    static BeerInfoDataModel *__sharedDataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedDataModel = [[BeerInfoDataModel alloc] init];
    });
    
    return __sharedDataModel;
}

- (NSManagedObjectModel *)managedObjectModel {
    return [NSManagedObjectModel mergedModelFromBundles:nil];
}

- (id)optionsForSqliteStore {
    return @{
             NSInferMappingModelAutomaticallyOption: @YES,
             NSMigratePersistentStoresAutomaticallyOption: @YES
            };
}

- (void)setup {
    self.objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"beerInfo.sqlite"];
    NSLog(@"Setting up store at %@", path);
    [self.objectStore addSQLitePersistentStoreAtPath:path
                              fromSeedDatabaseAtPath:nil
                                   withConfiguration:nil
                                             options:[self optionsForSqliteStore]
                                               error:nil];
    [self.objectStore createManagedObjectContexts];
}

@end
