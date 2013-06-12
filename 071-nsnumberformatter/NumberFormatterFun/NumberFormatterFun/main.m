//
//  main.m
//  NumberFormatterFun
//
//  Created by ben on 6/8/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/"
                                                                                           error:nil];
        NSNumber *freeSpace = attributes[NSFileSystemFreeSize];
        long long space = [freeSpace longLongValue] / (1024^2);
    
        NSLog(@"Free space: %@ MB", [NSNumberFormatter localizedStringFromNumber:@(space)
                                                                     numberStyle:NSNumberFormatterDecimalStyle]);
        
        NSNumber *amount = @(-29.42);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setNegativeFormat:@"(¤00.0)"];
        NSLocale *spainLocale = [NSLocale currentLocale];
        [formatter setLocale:spainLocale];
        
        
        NSLog(@"I have %@ in my wallet", [formatter stringFromNumber:amount]);
    }
    return 0;
}

