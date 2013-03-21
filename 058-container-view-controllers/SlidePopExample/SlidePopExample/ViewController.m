//
//  ViewController.m
//  SlidePopExample
//
//  Created by ben on 3/19/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "SlidePopContainerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)pushTapped:(id)sender {
    DetailViewController *dvc = [[DetailViewController alloc] init];
    [self.slidePopContainer pushViewController:dvc];
}

@end
