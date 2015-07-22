//
//  JMImageCache.m
//  JMCache
//
//  Created by Jake Marsh on 2/7/11.
//  Copyright 2011 Jake Marsh. All rights reserved.
//

#import "JMImageCache.h"

static NSString *_JMImageCacheDirectory;

static inline NSString *JMImageCacheDirectory() {
	if(!_JMImageCacheDirectory) {
		_JMImageCacheDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/JMCache"] copy];
	}

	return _JMImageCacheDirectory;
}
inline static NSString *keyForURL(NSURL *url) {
	return [url absoluteString];
}
static inline NSString *cachePathForKey(NSString *key) {
    NSString *fileName = [NSString stringWithFormat:@"JMImageCache-%u", [key hash]];
	return [JMImageCacheDirectory() stringByAppendingPathComponent:fileName];
}

JMImageCache *_sharedCache = nil;

@interface JMImageCache ()

@property (strong, nonatomic) NSOperationQueue *diskOperationQueue;

- (void) _downloadAndWriteImageForURL:(NSURL *)url key:(NSString *)key completionBlock:(void (^)(UIImage *image))completion;

@end

@implementation JMImageCache

@synthesize diskOperationQueue = _diskOperationQueue;

+ (JMImageCache *) sharedCache {
	if(!_sharedCache) {
		_sharedCache = [[JMImageCache alloc] init];
	}

	return _sharedCache;
}

- (id) init {
    self = [super init];
    if(!self) return nil;

    self.diskOperationQueue = [[NSOperationQueue alloc] init];

    [[NSFileManager defaultManager] createDirectoryAtPath:JMImageCacheDirectory()
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
	return self;
}

- (void) _downloadAndWriteImageForURL:(NSURL *)url key:(NSString *)key completionBlock:(void (^)(UIImage *image))completion {
    if (!key && !url) return;

    if (!key) {
        key = keyForURL(url);
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *i = [[UIImage alloc] initWithData:data];
        // stop process if the method could not initialize the image from the specified data
        if (!i) return;
        
        NSString *cachePath = cachePathForKey(key);
        NSInvocation *writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];

        [writeInvocation setTarget:self];
        [writeInvocation setSelector:@selector(writeData:toPath:)];
        [writeInvocation setArgument:&data atIndex:2];
        [writeInvocation setArgument:&cachePath atIndex:3];

        [self performDiskWriteOperation:writeInvocation];
        [self setImage:i forKey:key];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) completion(i);
        });
    });
}

- (void) removeAllObjects {
    [super removeAllObjects];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:JMImageCacheDirectory() error:&error];

        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [JMImageCacheDirectory() stringByAppendingPathComponent:path];

                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                if (!removeSuccess) {
                    //Error Occured
                }
            }
        } else {
            //Error Occured
        }
    });
}
- (void) removeObjectForKey:(id)key {
    [super removeObjectForKey:key];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *cachePath = cachePathForKey(key);

        NSError *error = nil;

        BOOL removeSuccess = [fileMgr removeItemAtPath:cachePath error:&error];
        if (!removeSuccess) {
            //Error Occured
        }
    });
}

#pragma mark -
#pragma mark Getter Methods

- (void) imageForURL:(NSURL *)url key:(NSString *)key completionBlock:(void (^)(UIImage *image))completion {

	UIImage *i = [self cachedImageForKey:key];

	if(i) {
		if(completion) completion(i);
	} else {
        [self _downloadAndWriteImageForURL:url key:key completionBlock:completion];
    }
}

- (void) imageForURL:(NSURL *)url completionBlock:(void (^)(UIImage *image))completion {
    [self imageForURL:url key:keyForURL(url) completionBlock:completion];
}

- (UIImage *) cachedImageForKey:(NSString *)key {
    if(!key) return nil;

	id returner = [super objectForKey:key];

	if(returner) {
        return returner;
	} else {
        UIImage *i = [self imageFromDiskForKey:key];
        if(i) [self setImage:i forKey:key];

        return i;
    }

    return nil;
}

- (UIImage *) cachedImageForURL:(NSURL *)url {
    NSString *key = keyForURL(url);
    return [self cachedImageForKey:key];
}

- (UIImage *) imageForURL:(NSURL *)url key:(NSString*)key delegate:(id<JMImageCacheDelegate>)d {
	if(!url) return nil;

	UIImage *i = [self cachedImageForURL:url];

	if(i) {
		return i;
	} else {
        [self _downloadAndWriteImageForURL:url key:key completionBlock:^(UIImage *image) {
            if(d) {
                if([d respondsToSelector:@selector(cache:didDownloadImage:forURL:)]) {
                    [d cache:self didDownloadImage:image forURL:url];
                }
                if([d respondsToSelector:@selector(cache:didDownloadImage:forURL:key:)]) {
                    [d cache:self didDownloadImage:image forURL:url key:key];
                }
            }
        }];
    }

    return nil;
}

- (UIImage *) imageForURL:(NSURL *)url delegate:(id<JMImageCacheDelegate>)d {
    return [self imageForURL:url key:keyForURL(url) delegate:d];
}

- (UIImage *) imageFromDiskForKey:(NSString *)key {
	UIImage *i = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:cachePathForKey(key) options:0 error:NULL]];
	return i;
}

- (UIImage *) imageFromDiskForURL:(NSURL *)url {
    return [self imageFromDiskForKey:keyForURL(url)];
}

#pragma mark -
#pragma mark Setter Methods

- (void) setImage:(UIImage *)i forKey:(NSString *)key {
	if (i) {
		[super setObject:i forKey:key];
	}
}
- (void) setImage:(UIImage *)i forURL:(NSURL *)url {
    [self setImage:i forKey:keyForURL(url)];
}
- (void) removeImageForKey:(NSString *)key {
	[self removeObjectForKey:key];
}
- (void) removeImageForURL:(NSURL *)url {
    [self removeImageForKey:keyForURL(url)];
}

#pragma mark -
#pragma mark Disk Writing Operations

- (void) writeData:(NSData*)data toPath:(NSString *)path {
	[data writeToFile:path atomically:YES];
}
- (void) performDiskWriteOperation:(NSInvocation *)invoction {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invoction];
    
	[self.diskOperationQueue addOperation:operation];
}

@end