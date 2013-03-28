//
//  NSCSignInViewController.h
//  NSScreencastChat
//
//  Created by ben on 3/10/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowsAzureMobileServices.h"

@interface NSCSignInViewController : UIViewController

/* Required to be set by the presenting view controller before view controller is presented. */
@property (nonatomic, strong) MSClient *client;

@end
