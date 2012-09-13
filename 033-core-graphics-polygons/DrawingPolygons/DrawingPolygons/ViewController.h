//
//  ViewController.h
//  DrawingPolygons
//
//  Created by Ben Scheirman on 9/9/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet PolygonView *shapeView;
@property (weak, nonatomic) IBOutlet UILabel *sidesLabel;

- (IBAction)slideerChanged:(id)sender;

@end
