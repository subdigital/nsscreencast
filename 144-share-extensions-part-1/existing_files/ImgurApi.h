//
//  ImgurApi.h
//  ImgShare
//
//  Created by Ben Scheirman on 11/2/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurApi : NSObject

+ (instancetype)sharedApi;

- (void)fetchGalleryWithCompletion:(void (^)(NSArray *images))completion;

- (void)uploadImageAtURL:(NSURL *)url withTitle:(NSString *)title completion:(void (^)(BOOL success, NSError *error))completion;

@end
