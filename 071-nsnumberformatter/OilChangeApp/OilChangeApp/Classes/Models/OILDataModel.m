//
//  OILDataModel.m
//  OilChangeApp
//
//  Created by ben on 5/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "OILDataModel.h"

@interface OILDataModel ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;

@end

@implementation OILDataModel

+ (id)shareDataModel {
    static OILDataModel *__instance;
    if (!__instance) {
        __instance = [[self alloc] init];
    }
    return __instance;
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = self.psc;
    }
    return _mainContext;
}

- (NSManagedObjectContext *)buildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    context.persistentStoreCoordinator = self.psc;
    return context;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelUrl = [NSURL fileURLWithPath:[self pathToModel]];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    }
    
    return _managedObjectModel;
}

- (NSDictionary *)storeOptions {
    return @{
             NSMigratePersistentStoresAutomaticallyOption: @YES,
             NSInferMappingModelAutomaticallyOption: @YES
             };
}

- (void)addPersistentStore:(NSPersistentStoreCoordinator *)psc {
    NSURL *storeUrl = [NSURL fileURLWithPath:[self pathToLocalStore]];
    NSError *error = nil;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeUrl
                                 options:[self storeOptions]
                                   error:&error]) {
        NSDictionary *userInfo = @{NSUnderlyingErrorKey: error};
        NSString *reason = @"Couldn't add persistent store.";
        NSLog(@"%@: %@", reason, error);
        NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:reason
                                                 userInfo:userInfo];
        @throw exc;
    }
}

- (NSPersistentStoreCoordinator *)psc {
    if (!_psc) {
        [self copyDefaultStoreIfNeeded];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [self addPersistentStore:psc];
        _psc = psc;
    }
    return _psc;
}

- (void)copyDefaultStoreIfNeeded {
    NSString *localStorePath = [self pathToLocalStore];
    NSString *defaultStorePath = [self pathToDefaultStore];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL localDbExists = [fileManager fileExistsAtPath:localStorePath];
    BOOL defaultDbExists = [fileManager fileExistsAtPath:defaultStorePath];
    
    if (!localDbExists && defaultDbExists) {
        if (![fileManager copyItemAtPath:defaultStorePath
                                  toPath:localStorePath
                                   error:&error]) {
            NSLog(@"Error copying %@ to %@!  %@", defaultStorePath, localStorePath, error);
        }
    }
}

- (NSString *)modelName {
    return [[[NSBundle mainBundle] bundleIdentifier] pathExtension];
}

- (NSString *)pathToModel {
    NSString *filename = [self modelName];
    NSString *localModelPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"momd"];
    NSAssert1(localModelPath, @"Couldn't find '%@.momd'", filename);
    return localModelPath;
}

- (NSString *)storeFilename {
    return [[self modelName] stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore {
    NSString *storeName = [self storeFilename];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docPath stringByAppendingPathComponent:storeName];
}

- (NSString *)pathToDefaultStore {
    NSString *storeName = [self storeFilename];
    return [[NSBundle mainBundle] pathForResource:storeName ofType:nil];
}

@end
