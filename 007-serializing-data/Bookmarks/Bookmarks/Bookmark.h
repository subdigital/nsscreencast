//
//  Bookmark.h
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject <NSCoding>

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *url;

@end
