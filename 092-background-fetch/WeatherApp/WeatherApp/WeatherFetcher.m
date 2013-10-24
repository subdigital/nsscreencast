//
//  WeatherFetcher.m
//  WeatherApp
//
//  Created by ben on 10/21/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "WeatherFetcher.h"

@implementation WeatherResult

- (id)initWithLocation:(NSString *)location temperature:(CGFloat)temperature updatedAt:(NSDate *)updatedAt {
    self = [super init];
    if (self) {
        _location = location;
        _temperature = temperature;
        _updatedAt = updatedAt;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _location = [aDecoder decodeObjectForKey:@"location"];
        _temperature = [aDecoder decodeFloatForKey:@"temperature"];
        _updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeFloat:self.temperature forKey:@"temperature"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
}

@end

@implementation WeatherFetcher

+ (WeatherFetcher *)sharedInstance {
    static WeatherFetcher *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [docsDir stringByAppendingPathComponent:@"weatherResult.plist"];
        _sharedInstance = [[WeatherFetcher alloc] initWithCacheFile:path];
    });
    
    return _sharedInstance;
}

- (id)initWithCacheFile:(NSString *)cacheFile {
    self = [super init];
    if (self) {
        _cacheFile = cacheFile;
    }
    return self;
}

- (WeatherResult *)cachedResult {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFile]) {
        WeatherResult *cachedResult = [NSKeyedUnarchiver unarchiveObjectWithFile:self.cacheFile];
        return cachedResult;
    }
    
    return nil;
}

- (void)cacheResult:(WeatherResult *)result {
    [NSKeyedArchiver archiveRootObject:result toFile:self.cacheFile];
}

- (void)fetchWeatherForLocation:(NSString *)location completion:(WeatherResultCompletionBlock)completion {
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        int temp = arc4random() % 1200 - 100;
        CGFloat tempWithDecimal = temp / 10.0f;
        NSDate *updatedAt = [NSDate date];
        
        WeatherResult *result = [[WeatherResult alloc] initWithLocation:location
                                                            temperature:tempWithDecimal
                                                              updatedAt:updatedAt];

        [self cacheResult:result];
        
        completion(result);
    });

}

@end
