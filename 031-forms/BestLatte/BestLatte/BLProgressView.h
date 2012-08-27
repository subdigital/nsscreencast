//
//  BLProgressView.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLProgressView : UIView

+ (id)presentInWindow:(UIWindow *)window;

- (void)dismiss;
- (void)setProgress:(CGFloat)progress;

@end
