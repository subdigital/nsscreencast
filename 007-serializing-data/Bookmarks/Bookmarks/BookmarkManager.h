//
//  BookmarkManager.h
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkManager : NSObject {
    NSString *_path;
    NSMutableArray *_bookmarks;
}

+ (id)sharedManager;

- (NSArray *)bookmarks;
- (void)addBookmark:(NSString *)url name:(NSString *)name;

@end
