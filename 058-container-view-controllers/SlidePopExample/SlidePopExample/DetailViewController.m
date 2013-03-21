//
//  DetailViewController.m
//  SlidePopExample
//
//  Created by ben on 3/19/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "DetailViewController.h"
#import "SlidePopContainerViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (IBAction)popTapped:(id)sender {
    [self.slidePopContainer popViewController];
}

@end
