//
//  ViewController.h
//  FunWithBlocks
//
//  Created by Ben Scheirman on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    UIImageView *_wallpaperView;
    UIActivityIndicatorView *_indicator;
    NSArray *_wallpapers;
    NSInteger _lastWallpaperIndex;
}

@end
