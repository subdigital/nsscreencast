//
//  DetailViewController.h
//  SearchStore
//
//  Created by Ben Scheirman on 9/30/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
