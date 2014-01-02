//
//  main.m
//  PredicateFun
//
//  Created by ben on 12/31/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

// very naive CSV implementation, but suits our needs
NSArray *loadCSV(NSString *filename) {
    NSString *dir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *csvPath = [dir stringByAppendingPathComponent:filename];
    
    NSLog(@"Loading CSV from: %@", csvPath);
    assert([[NSFileManager defaultManager] fileExistsAtPath:csvPath]);
    
    NSString *contents = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [contents componentsSeparatedByString:@"\r\n"];
    
    // first line has headers
    NSRange validRange = NSMakeRange(1, lines.count - 1);
    lines = [lines subarrayWithRange:validRange];
    
    NSMutableArray *records = [NSMutableArray array];
    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        NSArray *values = [line componentsSeparatedByString:@","];
        NSLog(@"Values: %@", values);
        
        if (values.count <= 6) {
            return;
        }
        
        int i = 0;
        id record = @{
                       @"firstName": values[++i],
                       @"lastName":  values[++i],
                       @"age":       @([values[++i] intValue]),
                       @"city":      values[++i],
                       @"state":     values[++i],
                       @"zip":       values[++i]
                     };
        [records addObject:record];
    }];
    
    return records;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *people = [NSMutableArray array];
        [loadCSV(@"fakenames.csv") enumerateObjectsUsingBlock:^(NSDictionary *record, NSUInteger idx, BOOL *stop) {
            Person *p = [[Person alloc] init];
            p.firstName = record[@"firstName"];
            p.lastName = record[@"lastName"];
            p.age = record[@"age"];
            
            p.address = [[Address alloc] init];
            p.address.city = record[@"city"];
            p.address.state = record[@"state"];
            p.address.zip = record[@"zip"];
            
            [people addObject:p];
        }];
        
        NSLog(@"All records: %@", people);
        
        NSPredicate *minors = [NSPredicate predicateWithFormat:@"age < 18"];
        NSLog(@"Minors: %@", [people filteredArrayUsingPredicate:minors]);
        
        NSPredicate *aNames = [NSPredicate predicateWithFormat:@"lastName BEGINSWITH[cd] %@ OR firstName BEGINSWITH[cd] %@", @"a", @"a"];
        NSLog(@"A names: %@", [people filteredArrayUsingPredicate:aNames]);
        
        NSPredicate *statePredicate = [NSPredicate predicateWithFormat:@"address.state == $state"];
        NSPredicate *oregonians = [statePredicate predicateWithSubstitutionVariables:@{ @"state": @"OR" }];
        NSLog(@"Oregonians: %@", [people filteredArrayUsingPredicate:oregonians]);
        
        NSPredicate *texans = [statePredicate predicateWithSubstitutionVariables:@{ @"state": @"TX"}];
        NSPredicate *texasMinors = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                               subpredicates:@[ texans, minors]];
        NSLog(@"Texas minors: %@", [people filteredArrayUsingPredicate:texasMinors]);
    }
    return 0;
}



































        // minors
        
        // names starting with a
        
        // long names
        
        // oregonians
        
        // texans
        
        // texasMinors