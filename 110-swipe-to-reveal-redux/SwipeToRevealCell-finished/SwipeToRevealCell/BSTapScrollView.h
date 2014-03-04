//
//  TapScrollView.h
//  SwipeToRevealCell
//
//  Created by ben on 2/27/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSTapScrollViewDelegate;

@interface BSTapScrollView : UIScrollView

@property (nonatomic, weak) id<BSTapScrollViewDelegate> tapDelegate;

@end


@protocol BSTapScrollViewDelegate <NSObject>

@optional

- (void)tapScrollView:(BSTapScrollView *)scrollView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tapScrollView:(BSTapScrollView *)scrollView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tapScrollView:(BSTapScrollView *)scrollView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end