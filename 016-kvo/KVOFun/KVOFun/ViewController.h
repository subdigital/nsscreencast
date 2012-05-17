//
//  ViewController.h
//  KVOFun
//
//  Created by Ben Scheirman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    ViewColorRed = 0,
    ViewColorGreen,
    ViewColorBlue
};

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *label;

- (IBAction)changeColor:(id)sender;

@end
