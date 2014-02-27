//
//  MDMPersistenceController.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 Posted whenever the Core Data stack is completely setup.
 */
extern NSString *const MDMPersistenceControllerDidInitialize;

/**
 `MDMPersistenceController` is a lightweight class that sets up an efficient Core Data stack with support for
 creating multiple child managed object contexts. A private managed object context is used for asynchronous
 saving. A SQLite store is used for data persistence.
 */
@interface MDMPersistenceController : NSObject

/**
 The persistence controller's main managed object context. (read-only)
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 Returns a persistence controller initialized with the given arguments.
 
 @param storeURL The URL of the SQLite store to load.
 @param model A managed object model.

 @return A new persistence controller object with a store at the specified location with model.
 */
- (id)initWithStoreURL:(NSURL *)storeURL model:(NSManagedObjectModel *)model;

/**
 Returns a persistence controller initialized with the given arguments.
 
 @param storeURL The URL of the SQLite store to load.
 @param modelURL The URL of the managed object model.

 @return A new persistence controller object with a store at the specified location and a model at the specified location.
 */
- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

/**
 Returns a new private child managed object context with a concurrency type of `NSPrivateQueueConcurrencyType`.
 
 @return A new managed object context object.
 */
- (NSManagedObjectContext *)newPrivateChildManagedObjectContext;

/**
 Returns a new child managed object context with a concurrency type of `NSMainQueueConcurrencyType`.
 
 @return A new managed object context object.
 */
- (NSManagedObjectContext *)newChildManagedObjectContext;

/**
 Attempts to commit unsaved changes to registered objects to disk.
 
 @param wait If set the primary context is saved synchronously otherwise asynchronously.
 @param completion An optional block to be executed when saving has completed.
 */
- (void)saveContextAndWait:(BOOL)wait completion:(void (^)(NSError *error))completion;

/**
 Executes the given fetch request with the main managedObjectContext
 and returns an array of results if successful, otherwise returns nil and calls the 
 error block.
 
 @param request An NSFetchRequest that will execute on the managedObjectContext.
 @param error A block that will be called if an error occurs during the fetch.
 
 @return An NSArray of the results, or nil if an error occured. If there were no results
 and no error, an empty array is returned.
 */
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(void (^)(NSError *error))errorBlock;

/**
 Deletes the given NSMangedObject using the main managedObjectContext and saves the changes by
 Passing the given BOOL and completion block as parameters to `-saveContextAndWait:completion:`.
 
 @param object The NSMangedObject to delete.
 @param saveAndWait The BOOL that will be passed to `-saveContextAndWait:completion:`
 @param completion An optional block that will be passed to `-saveContextAndWait:completion:`.
 */
- (void)deleteObject:(NSManagedObject *)object saveContextAndWait:(BOOL)saveAndWait completion:(void (^)(NSError *error))completion;
    
@end
