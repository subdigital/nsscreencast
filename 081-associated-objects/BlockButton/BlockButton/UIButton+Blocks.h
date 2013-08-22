//
//  UIButton+Blocks.h
//  BlockButton
//
//  Created by ben on 8/20/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock)();

@interface UIButton (Blocks)

- (void)addTargetWithBlock:(ButtonBlock)block;

@end
