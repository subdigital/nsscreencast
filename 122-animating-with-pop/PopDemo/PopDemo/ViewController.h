//
//  ViewController.h
//  PopDemo
//
//  Created by Ben Scheirman on 5/18/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)pan:(id)sender;

@end
