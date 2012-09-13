//
//  ViewController.m
//  DrawingPolygons
//
//  Created by Ben Scheirman on 9/9/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setShapeView:nil];
    [self setSidesLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)slideerChanged:(id)sender {
    UISlider *slider = sender;
    int sides = (int)slider.value;
    self.shapeView.numberOfSides = sides;
    self.sidesLabel.text = [NSString stringWithFormat:@"%d", sides];
}

@end
