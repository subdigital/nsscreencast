//
//  RKWikiPage.h
//  restkit-object-manager
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCategory.h"
#import "WKSlug.h"

@interface WKWikiPage : NSObject

@property (nonatomic, assign) NSInteger pageID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) WKSlug *slug;
@property (nonatomic, strong) WKCategory *category;

@end

