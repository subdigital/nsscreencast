//
//  BLLatte.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLLatte : NSObject

+ (void)fetchLattes:(void (^)(NSArray *lattes, NSError *error))completionBlock;

@property (nonatomic, assign) NSInteger serverId;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *largeUrl;
@property (nonatomic, strong) NSString *submittedBy;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSData *photoData;

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;

@end
