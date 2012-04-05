//
//  ViewController.m
//  FunWithBlocks
//
//  Created by Ben Scheirman on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

typedef void (^ImageCompletionBlock)(UIImage *);
typedef void (^ActionBlock)();

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wallpaperView = [[UIImageView alloc] initWithImage:nil];
    _wallpaperView.frame = self.view.bounds;
    _wallpaperView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_wallpaperView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.hidesWhenStopped = YES;
    _indicator.center = self.view.center;
    [self.view addSubview:_indicator];
    
    _wallpapers = [NSArray arrayWithObjects:@"http://www.fantasywallpapers.in/bulkupload/Fantasy/Others/Fantasy-01.jpg",
                   @"http://www.fantasywallpapers.in/bulkupload/Fantasy/Space/Fantasy%20space-03.jpg", 
                   @"http://images2.alphacoders.com/115/115462.jpg", nil];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(loadWallpaper)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    
    [self loadWallpaper];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)fetchImageWithURL:(NSURL *)url completionBlock:(ImageCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        NSLog(@"Image size: %@", NSStringFromCGSize(image.size));

        [self resizeImage:image toWidth:self.view.frame.size.width completionBlock:completionBlock];
    });    
}

- (void)resizeImage:(UIImage *)image toWidth:(CGFloat)width completionBlock:(ImageCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        UIImage *thumbImage = nil;
        CGSize newSize = CGSizeMake(width, (width / image.size.width) * image.size.height);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        completion(thumbImage);
    });
}

- (void)scaleImageTo:(CGFloat)scale completion:(ActionBlock)completion {
    CGFloat duration = 0.25f;
    [UIView animateWithDuration:duration animations:^{
        _wallpaperView.transform = CGAffineTransformMakeScale(scale, scale);        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();   
        }
    }];
}

- (void)bounceImage {
    [self scaleImageTo:1.1 completion:^{
        [self scaleImageTo:0.9 completion:^{
            [self scaleImageTo:1.0 completion:nil]; 
        }];
    }];
}

- (void)loadWallpaper {
    [_indicator startAnimating];

    [UIView animateWithDuration:0.5 animations:^{
        _wallpaperView.alpha = 0; 
    }];

    
    NSURL *url = [NSURL URLWithString:[_wallpapers objectAtIndex:_lastWallpaperIndex]];
    _lastWallpaperIndex += 1;
    if (_lastWallpaperIndex >= _wallpapers.count) {
        _lastWallpaperIndex = 0;
    }
    
    [self fetchImageWithURL:url completionBlock:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _wallpaperView.image = image;
            [_indicator stopAnimating];
            
            [UIView animateWithDuration:0.5 animations:^{
                _wallpaperView.alpha = 1; 
            }];
            
            [self bounceImage];
        });
    }];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
