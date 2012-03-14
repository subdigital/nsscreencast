//
//  Bookmark.m
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

@synthesize label = _label;
@synthesize url = _url;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.label = [aDecoder decodeObjectForKey:@"label"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.label forKey:@"label"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (void)dealloc {
    [_label release];
    [_url release];
    [super dealloc];
}

@end
