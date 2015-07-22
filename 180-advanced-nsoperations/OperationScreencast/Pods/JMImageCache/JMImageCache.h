//
//  JMImageCache.h
//  JMCache
//
//  Created by Jake Marsh on 2/7/11.
//  Copyright 2011 Jake Marsh. All rights reserved.
//

#import "UIImageView+JMImageCache.h"

@class JMImageCache;

@protocol JMImageCacheDelegate <NSObject>

@optional
- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSURL *)url;
- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSURL *)url key:(NSString*)key;

@end

@interface JMImageCache : NSCache

+ (JMImageCache *) sharedCache;

- (void) imageForURL:(NSURL *)url key:(NSString *)key completionBlock:(void (^)(UIImage *image))completion;
- (void) imageForURL:(NSURL *)url completionBlock:(void (^)(UIImage *image))completion;

- (UIImage *) cachedImageForKey:(NSString *)key;
- (UIImage *) cachedImageForURL:(NSURL *)url;

- (UIImage *) imageForURL:(NSURL *)url key:(NSString*)key delegate:(id<JMImageCacheDelegate>)d;
- (UIImage *) imageForURL:(NSURL *)url delegate:(id<JMImageCacheDelegate>)d;

- (UIImage *) imageFromDiskForKey:(NSString *)key;
- (UIImage *) imageFromDiskForURL:(NSURL *)url;

- (void) setImage:(UIImage *)i forKey:(NSString *)key;
- (void) setImage:(UIImage *)i forURL:(NSURL *)url;
- (void) removeImageForKey:(NSString *)key;
- (void) removeImageForURL:(NSString *)url;

- (void) writeData:(NSData *)data toPath:(NSString *)path;
- (void) performDiskWriteOperation:(NSInvocation *)invoction;

@end
