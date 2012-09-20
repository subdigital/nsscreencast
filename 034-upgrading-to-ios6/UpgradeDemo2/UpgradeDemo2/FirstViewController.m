//
//  FirstViewController.m
//  UpgradeDemo2
//
//  Created by Ben Scheirman on 9/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.colorView.frame = CGRectMake(0, 0, 320, 416);
}

- (UIColor *)randomColor {
    NSArray *colors = @[
    [UIColor redColor],
    [UIColor blueColor],
    [UIColor yellowColor],
    [UIColor greenColor],
    [UIColor purpleColor],
    [UIColor grayColor]
    ];
    
    int index = arc4random() % colors.count;
    return [colors objectAtIndex:index];
}


- (BOOL)isPhone5 {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            
            CGFloat height = [[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] scale];
            return height == 1136;
            
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (IBAction)changeColor:(id)sender {
    self.colorView.backgroundColor = [self randomColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight |
    UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
