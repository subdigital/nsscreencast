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
        _path = [[documentsDirectory stringByAppendingPathComponent:@"bookmarks.plist"] retain];
        NSLog(@"Saving bookmarks to %@", _path);
    }
    
    return self;
}

- (void)dealloc {
    [_path release];
    [_bookmarks release];
    [super dealloc];
}

- (void)loadBookmarks {
    _bookmarks = [[NSArray arrayWithContentsOfFile:_path] retain];
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

- (void)addBookmark:(NSString *)url name:(NSString *)name {
    if (!_bookmarks) 
        [self loadBookmarks];
    
    NSLog(@"Adding bookmark [name: %@] [url: %@]", name, url);
    
    NSDictionary *bookmarkDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        name, @"name",
                                        url,  @"url", nil];
    [_bookmarks addObject:bookmarkDictionary];
    [_bookmarks writeToFile:_path atomically:YES];
}


@end
