//
//  WARAppDelegate.h
//  WhatsAround
//
//  Created by ben on 4/16/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WARState.h"

@interface WARAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *states;

@end
