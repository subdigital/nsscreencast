//
//  UIImageView+JMImageCache.m
//  JMImageCacheDemo
//
//  Created by Jake Marsh on 7/23/12.
//  Copyright (c) 2012 Jake Marsh. All rights reserved.
//

#import "UIImageView+JMImageCache.h"
#import "JMImageCache.h"
#import <objc/runtime.h>

static char kJMImageURLObjectKey;

@interface UIImageView (_JMImageCache)

@property (readwrite, nonatomic, retain, setter = jm_setImageURL:) NSURL *jm_imageURL;

@end

@implementation UIImageView (_JMImageCache)

@dynamic jm_imageURL;

@end

@implementation UIImageView (JMImageCache)

#pragma mark - Private Setters

- (NSURL *) jm_imageURL {
    return (NSURL *)objc_getAssociatedObject(self, &kJMImageURLObjectKey);
}
- (void) jm_setImageURL:(NSURL *)imageURL {
    objc_setAssociatedObject(self, &kJMImageURLObjectKey, imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Methods

- (void) setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholder:nil];
}
- (void) setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholderImage {
    [self setImageWithURL:url key:nil placeholder:placeholderImage];
}
- (void) setImageWithURL:(NSURL *)url key:(NSString*)key placeholder:(UIImage *)placeholderImage {
    self.jm_imageURL = url;
    self.image = placeholderImage;

    [self setNeedsDisplay];
    [self setNeedsLayout];

    __weak UIImageView *safeSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *i;

        if (key) {
            i = [[JMImageCache sharedCache] cachedImageForKey:key];
        } else {
            i = [[JMImageCache sharedCache] cachedImageForURL:url];
        }

        if(i) {
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.jm_imageURL = nil;
                safeSelf.image = i;


                [safeSelf setNeedsLayout];
                [safeSelf setNeedsDisplay];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.image = placeholderImage;

                [safeSelf setNeedsDisplay];
                [safeSelf setNeedsLayout];
            });

            [[JMImageCache sharedCache] imageForURL:url key:key completionBlock:^(UIImage *image) {
                if ([url isEqual:safeSelf.jm_imageURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(image) {
                            safeSelf.image = image;
                        } else {
                            safeSelf.image = placeholderImage;
                        }

                        safeSelf.jm_imageURL = nil;

                        [safeSelf setNeedsLayout];
                        [safeSelf setNeedsDisplay];
                    });
                }
            }];
        }
    });
}

@end