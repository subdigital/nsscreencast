//
//  BookmarkManager.m
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "BookmarkManager.h"

@implementation BookmarkManager

+ (id)sharedManager {
    static BookmarkManager *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[BookmarkManager alloc] init];
    });
    
    return __instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *documentsDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        _path = [[documentsDirectory stringByAppendingPathComponent:@"bookmarks.dat"] retain];
        NSLog(@"Saving bookmarks in %@", _path);
    }
    
    return self;
}

- (void)dealloc {
    [_bookmarks release];
    [_path release];
    [super dealloc];
}

- (void)loadBookmarks {
    _bookmarks = [[NSKeyedUnarchiver unarchiveObjectWithFile:_path] retain];
    if (!_bookmarks) {
        _bookmarks = [[NSMutableArray array] retain];        
    }
}

- (NSArray *)bookmarks {
    if (!_bookmarks) {
        [self loadBookmarks];
    }
    return _bookmarks;
}

- (void)addBookmark:(Bookmark *)bookmark {
    if (!_bookmarks) 
        [self loadBookmarks];
    
    NSLog(@"Adding bookmark [name: %@] [url: %@]", bookmark.label, bookmark.url);
    
    [_bookmarks addObject:bookmark];
    
    [NSKeyedArchiver archiveRootObject:_bookmarks toFile:_path];
}

@end
