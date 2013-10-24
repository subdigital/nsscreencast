//
//  WeatherFetcher.h
//  WeatherApp
//
//  Created by ben on 10/21/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherResult : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) CGFloat temperature;
@property (nonatomic, readonly) NSDate *updatedAt;

@end

typedef void (^WeatherResultCompletionBlock)(WeatherResult *result);

@interface WeatherFetcher : NSObject

@property (nonatomic, readonly) NSString *cacheFile;

+ (WeatherFetcher *)sharedInstance;
- (WeatherResult *)cachedResult;
- (void)fetchWeatherForLocation:(NSString *)location completion:(WeatherResultCompletionBlock)completion;

@end
