//
//  ViewController.m
//  Versioner
//
//  Created by ben on 2/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableString *versionString = [NSMutableString string];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [mainBundle infoDictionary];
    NSString *marketingVersion = infoDictionary[@"CFBundleShortVersionString"];
    NSString *appVersion = infoDictionary[@"CFBundleVersion"];
    [versionString appendFormat:@"Marketing Version: %@\n", marketingVersion];
    [versionString appendFormat:@"Build: %@\n", appVersion];
    self.versionLabel.text = versionString;
}

@end
