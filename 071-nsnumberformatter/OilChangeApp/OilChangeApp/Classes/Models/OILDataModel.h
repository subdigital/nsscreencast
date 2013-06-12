//
//  OILDataModel.h
//  OilChangeApp
//
//  Created by ben on 5/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface OILDataModel : NSObject

+ (id)shareDataModel;

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *psc;

- (NSManagedObjectContext *)buildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (void)addPersistentStore:(NSPersistentStoreCoordinator *)coordinator;
- (NSDictionary *)storeOptions;
- (NSString *)pathToLocalStore;
    
@end
