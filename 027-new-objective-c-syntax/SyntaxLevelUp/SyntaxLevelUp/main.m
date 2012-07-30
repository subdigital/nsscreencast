//
//  main.m
//  SyntaxLevelUp
//
//  Created by Ben Scheirman on 7/29/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    Foo = 0,
    Bar,
    Baz
};

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSArray *items = @[@"item1", @"item2", @"item3"];
                
        BOOL skipBackup = YES;
        NSDictionary *options = @{
            @"backup" : @(!skipBackup),
            @"daysToKeepBackup" : @(20 - 2)
        };
        
        char * path = getenv("PATH");
        NSString *betterPath = @(path);
        NSLog(@"Path: %@", betterPath);
        
        NSLog(@"Items: ");
        for(int i=0; i<items.count; i++) {
            NSLog(@"  %d: %@", i, items[i]);
        }
        
        NSLog(@"Options: ");
        for (NSString *key in [options allKeys]) {
            NSLog(@"  %@: %@", key, options[key]);
        }
    }
    return 0;
}

