//
//  main.m
//  FunWithCollections
//
//  Created by ben on 6/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@end

@implementation Person

- (NSString *)description {
    return [NSString stringWithFormat:@"Person: %@", self.name];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[Person class]] && [self.name isEqual:[object name]];
}

- (NSUInteger)hash {
    return [self.name hash];
}

@end

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSArray *names = @[@"Adam", @"Brittany", @"Charles", @"Diane", @"Eugene", @"Fannie", @"Gregory", @"Heather", @"Ishmael", @"Jennifer", @"Kenny", @"Lindsay", @"Marcus", @"Nina", @"Oscar", @"Paige"];
        
        NSMutableArray *people = [NSMutableArray arrayWithCapacity:[names count]];
        for (NSString *name in names) {
            Person *person = [[Person alloc] init];
            person.name = name;
            [people addObject:person];
        }
        
        NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:people];

        Person *p1 = [[Person alloc] init];
        p1.name = @"Eugene";
        
        NSSet *namesToRemove = [NSSet setWithObjects:p1, nil];
        [set minusSet:namesToRemove];
        NSLog(@"Set: %@", set);

        NSCountedSet *countedSet = [NSCountedSet setWithArray:names];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        [countedSet addObject:@"Diane"];
        NSLog(@"Counts: %@", countedSet);
        
        NSDictionary *dict = @{@"people": people};
        
    }
    return 0;
}

