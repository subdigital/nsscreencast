//
//  PusherExampleMenuViewController.h
//  libPusher
//
//  Created by Luke Redpath on 14/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTPusher;

@interface PusherExampleMenuViewController : UITableViewController {
  NSArray *menuOptions; 
}
@property (nonatomic, strong) PTPusher *pusher;
@end
