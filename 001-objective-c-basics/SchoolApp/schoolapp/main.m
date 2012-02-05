//
//  main.m
//  schoolapp
//
//  Created by Ben Scheirman on 1/21/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"

int main (int argc, const char * argv[])
{
    @autoreleasepool {        
        
        Student *student = [[Student alloc] init];
        student.name = @"Bob";
        
        NSLog(@"Student: %@", student);
        
        [student release];
        
        NSLog(@"Press any key...");
        char input;
        scanf("%c", &input);
    }
    return 0;
}

