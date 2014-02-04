//
//  NSCRUnreadIndicator.h
//  nsscreencast-ios
//
//  Created by Ben Scheirman on 2/2/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSCRUnreadIndicator : UIView

@property (nonatomic, assign) BOOL hasRead;

- (void)setFillPercent:(CGFloat)percent;

@end
