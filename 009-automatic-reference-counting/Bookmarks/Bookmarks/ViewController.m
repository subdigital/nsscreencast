//
//  ViewController.m
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "BookmarkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bookmarks";
    id addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                  target:self
                                                                  action:@selector(onAdd:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)onAdd:(id)sender {
    AddBookmarkViewController *addController = [[AddBookmarkViewController alloc] init];
    addController.delegate = self;
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - AddBookmarkDelegate methods

- (void)addBookmarkViewControllerDidCancel:(AddBookmarkViewController *)viewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBookmarkViewController:(AddBookmarkViewController *)viewController didSaveBookmarkWithLabel:(NSString *)label url:(NSString *)url {    
    Bookmark *bookmark = [[Bookmark alloc] init];
    bookmark.label = label;
    bookmark.url = url;
    
    [[BookmarkManager sharedManager] addBookmark:bookmark];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BookmarkManager sharedManager] bookmarks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    Bookmark *bookmark = [[[BookmarkManager sharedManager] bookmarks] objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.label;
    cell.detailTextLabel.text = bookmark.url;
    
    return cell;
}

@end
