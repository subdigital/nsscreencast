//
//  MDMPersistenceController.m
//
//  Copyright (c) 2014 Matthew Morey.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MDMPersistenceController.h"
#import "MDMCoreDataMacros.h"

NSString *const MDMPersistenceControllerDidInitialize = @"MDMPersistenceControllerDidInitialize";

@interface MDMPersistenceController ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *writerObjectContext;
@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation MDMPersistenceController

- (id)initWithStoreURL:(NSURL *)storeURL model:(NSManagedObjectModel *)model {
    
    self = [super init];
    if (self) {
        _storeURL = storeURL;
        _model = model;
        if ([self setupPersistenceStack] == NO) {
            return nil;
        }
    }
    
    return self;
}

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL {
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(model, @"ERROR: NSManagedObjectModel is nil");
    
    return [self initWithStoreURL:storeURL model:model];
}

- (BOOL)setupPersistenceStack {
    
    // Create persistent store coordinator
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    ZAssert(persistentStoreCoordinator, @"ERROR: NSPersistentStoreCoordinator is nil");
    
    // Add persistent store to store coordinator
    NSDictionary *persistentStoreOptions = @{ // Light migration
                                             NSInferMappingModelAutomaticallyOption:@YES,
                                             NSMigratePersistentStoresAutomaticallyOption:@YES
                                             };
    NSError *persistentStoreError;
    NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                  configuration:nil
                                                                                            URL:self.storeURL
                                                                                        options:persistentStoreOptions
                                                                                          error:&persistentStoreError];
    if (persistentStore == nil) {
        
        // Model has probably changed, lets delete the old one and try again
        NSError *removeSQLiteFilesError = nil;
        if ([self removeSQLiteFilesAtStoreURL:self.storeURL error:&removeSQLiteFilesError]) {
            
            persistentStoreError = nil;
            persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:persistentStoreOptions
                                                                               error:&persistentStoreError];
        } else {
            
            ALog(@"ERROR: Could not remove SQLite files\n%@", [removeSQLiteFilesError localizedDescription]);
            
            return NO;
        }
        
        if (persistentStore == nil) {
            
            // Something really bad is happening
            ALog(@"ERROR: NSPersistentStore is nil: %@\n%@", [persistentStoreError localizedDescription], [persistentStoreError userInfo]);
            
            return NO;
        }
    }
    
    // Create managed object contexts
    self.writerObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.writerObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    if (self.writerObjectContext == nil) {
        
        // App is useless if a writer managed object context cannot be created
        ALog(@"ERROR: NSManagedObjectContext is nil");
        
        return NO;
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setParentContext:self.writerObjectContext];
    if (self.managedObjectContext == nil) {
        
        // App is useless if a managed object context cannot be created
        ALog(@"ERROR: NSManagedObjectContext is nil");
        
        return NO;
    }
    
    // Context is fully initialized, notify view controllers
    [self persistenceStackInitialized];
    
    return YES;
}

- (BOOL)removeSQLiteFilesAtStoreURL:(NSURL *)storeURL error:(NSError * __autoreleasing *)error {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeDirectory = [storeURL URLByDeletingLastPathComponent];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:storeDirectory
                                          includingPropertiesForKeys:nil
                                                             options:0
                                                        errorHandler:nil];
    
    NSString *storeName = [storeURL.lastPathComponent stringByDeletingPathExtension];
    for (NSURL *url in enumerator) {
        
        if ([url.lastPathComponent hasPrefix:storeName] == NO) {
            continue;
        }
        
        NSError *fileManagerError = nil;
        if ([fileManager removeItemAtURL:url error:&fileManagerError] == NO) {
           
            if (error != NULL) {
                *error = fileManagerError;
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)saveContextAndWait:(BOOL)wait completion:(void (^)(NSError *error))completion {
    
    if (self.managedObjectContext == nil) {
        return;
    }
    
    if ([self.managedObjectContext hasChanges] || [self.writerObjectContext hasChanges]) {
        
        [self.managedObjectContext performBlockAndWait:^{
            
            NSError *mainContextSaveError = nil;
            if ([self.managedObjectContext save:&mainContextSaveError] == NO) {
                
                ALog(@"ERROR: Could not save managed object context -  %@\n%@", [mainContextSaveError localizedDescription], [mainContextSaveError userInfo]);
                if (completion) {
                    completion(mainContextSaveError);
                }
                return;
            }
            
            if ([self.writerObjectContext hasChanges]) {
               
                if (wait) {
                    [self.writerObjectContext performBlockAndWait:[self savePrivateWriterContextBlockWithCompletion:completion]];
                } else {
                    [self.writerObjectContext performBlock:[self savePrivateWriterContextBlockWithCompletion:completion]];
                }
            }
        }]; // Managed Object Context block
    } // Managed Object Context has changes
}

- (void(^)())savePrivateWriterContextBlockWithCompletion:(void (^)(NSError *))completion {
    
    void (^savePrivate)(void) = ^{
        
        NSError *privateContextError = nil;
        if ([self.writerObjectContext save:&privateContextError] == NO) {
            
            ALog(@"ERROR: Could not save managed object context - %@\n%@", [privateContextError localizedDescription], [privateContextError userInfo]);
            if (completion) {
                completion(privateContextError);
            }
        } else {
            if (completion) {
                completion(nil);
            }
        }
    };
    
    return savePrivate;
}

#pragma mark - Child NSManagedObjectContext

- (NSManagedObjectContext *)newPrivateChildManagedObjectContext {
    
    NSManagedObjectContext *privateChildManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateChildManagedObjectContext setParentContext:self.managedObjectContext];
    
    return privateChildManagedObjectContext;
}

- (NSManagedObjectContext *)newChildManagedObjectContext {
    
    NSManagedObjectContext *childManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [childManagedObjectContext setParentContext:self.managedObjectContext];
    
    return childManagedObjectContext;
}

#pragma mark - NSNotificaitonCenter

- (void)persistenceStackInitialized {
    
    if ([NSThread isMainThread] == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postPersistenceStackInitializedNotification];
        });
    } else {
        [self postPersistenceStackInitializedNotification];
    }
}

- (void)postPersistenceStackInitializedNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MDMPersistenceControllerDidInitialize object:self];
}

#pragma mark - fetch and delete
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(void (^)(NSError *error))errorBlock {
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error && errorBlock) {
        errorBlock(error);
        return nil;
    }
    
    return results;
}

- (void)deleteObject:(NSManagedObject *)object saveContextAndWait:(BOOL)saveAndWait completion:(void (^)(NSError *error))completion {
    
    [self.managedObjectContext deleteObject:object];
    [self saveContextAndWait:saveAndWait completion:completion];
}

@end
