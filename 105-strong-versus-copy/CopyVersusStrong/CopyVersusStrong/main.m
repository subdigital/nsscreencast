//
//  main.m
//  CopyVersusStrong
//
//  Created by ben on 1/28/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSMutableString *name = [NSMutableString stringWithString:@"Bob"];
        NSMutableArray *things = [@[@"Ice Cream", @"Pizza"] mutableCopy];
        Person *p1 = [[Person alloc] init];
        p1.name = name;
        p1.favoriteThings = things;
        
        [name replaceCharactersInRange:NSMakeRange(0, name.length) withString:@"Fred"];
        [things addObject:@"Racecars"];
        Person *p2 = [[Person alloc] init];
        p2.name = name;
        p2.favoriteThings = things;
        
        NSLog(@"P1 name: %@", p1.name);
        NSLog(@"P1 favorite things: %@", p1.favoriteThings);
        NSLog(@"P2 name: %@", p2.name);
        NSLog(@"P2 favorite things: %@", p2.favoriteThings);
        
        NSDictionary *dict = @{ name: @"red" };
        [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@"A"];
        NSLog(@"Name hash: %lu", (unsigned long)[name hash]);
        NSLog(@"key hash: %lu", (unsigned long)[[dict allKeys][0] hash]);
        
    }
    return 0;
}

