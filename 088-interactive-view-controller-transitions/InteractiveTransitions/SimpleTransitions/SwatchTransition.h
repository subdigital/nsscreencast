//
//  SwatchTransition.h
//  SimpleTransitions
//
//  Created by ben on 9/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SwatchTransitionMode){
    SwatchTransitionModePresent = 0,
    SwatchTransitionModeDismiss
};

@interface SwatchTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) SwatchTransitionMode mode;

@end
