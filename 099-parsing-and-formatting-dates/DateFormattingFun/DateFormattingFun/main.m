//
//  main.m
//  DateFormattingFun
//
//  Created by ben on 12/9/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // 2013-12-08T05:27Z
        NSString *date1Str = @"2013-12-10T22:23:31Z";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
        NSDate *date = [dateFormatter dateFromString:date1Str];
        NSLog(@"Date: %@", date);
    }
    
    return 0;
}

