//
//  DetailViewController.h
//  HelloIOS7
//
//  Created by ben on 9/14/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
