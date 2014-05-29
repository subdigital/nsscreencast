//
//  MDMFetchedResultsTableDataSource.m
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

@class MDMFetchedResultsTableDataSource;

/**
 A delegate of a `MDMFetchedResultsTableDataSource` object must adopt the
 `MDMFetchedResultsTableDataSourceDelegate` protocol.
 */
@protocol MDMFetchedResultsTableDataSourceDelegate <NSObject>

@required
/**
 Tells the delegate to configure the table cell with the given object.
 
 @param cell The table cell to be configured by the delegate.
 @param object The object to be used to configure the cell.
 */
- (void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource configureCell:(id)cell withObject:(id)object;

/**
 Asks the delegate to delete the specified object.
 
 @param object The object to be deleted by the delegate.
 */
- (void)dataSource:(MDMFetchedResultsTableDataSource *)dataSource deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

/**
 The `MDMFetchedResultsTableDataSource` implements `NSFetchedResultsControllerDelegate` and `UITableViewDataSource` and 
 is used by a `UITableView` to access Core Data models.
 */
@interface MDMFetchedResultsTableDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

/**
 The `NSFetchedResultsController` to be used by the data source.
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 The reuse identifier of the cell being modified by the data source.
 */
@property (nonatomic, copy) NSString *reuseIdentifier;

/**
 A Boolean value that determines whether the receiver will update automatically when the model changes.
 */
@property (nonatomic) BOOL paused;

/**
 The object that acts as the delegate of the receiving data source.
 */
@property (nonatomic, weak) id<MDMFetchedResultsTableDataSourceDelegate> delegate;

/**
 Returns a fetched results table data source initialized with the given arguments.
 
 @param tableView The table view using this data source.
 @param fetchedResultsController The fetched results controller the data source should use.
 
 @return The newly-initialized table data source.
 */
- (id)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

/**
 Returns the currently selected item from the table.
 
 @return The selected item. If multiple items are selected it returns the first item.
 */
- (id)selectedItem;

/**
 Asks the data source to return the number of rows in the section.
 
 @param section An index number identifying a section for the internally managed table view.
 
 @return The number of rows in `section`. If section doesn't exist returns 0.
 */
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;

/**
 Asks the data source to return the total number of rows in all sections.
 
 @return Total number of rows.
 */
- (NSUInteger)numberOfRowsInAllSections;

/**
 Returns the item object at the specified index path.
 
 @param path The index path that specifies the section and row of the cell.
 
 @return The item object at the corresponding index path or `nil` if the index path is out of range.
 */
- (id)itemAtIndexPath:(NSIndexPath *)path;

/**
 Returns the index path of a given object.
 
 @param object An object in the receiver's fetch results.
 
 @return The index path of `object` in the receiver's fetch results, or nil if `object` could not be found.
 */
- (NSIndexPath *)indexPathForObject:(id)object;

@end