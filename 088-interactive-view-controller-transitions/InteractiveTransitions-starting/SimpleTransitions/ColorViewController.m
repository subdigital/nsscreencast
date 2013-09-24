//
//  ColorViewController.m
//  SimpleTransitions
//
//  Created by ben on 9/15/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()
@property (nonatomic, strong) UIColor *color;
@end

@implementation ColorViewController

- (id)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.color;
    self.view.layer.borderColor = [[UIColor blackColor] CGColor];
    self.view.layer.borderWidth = 1.0;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.tintColor = [UIColor blueColor];
    [dismissButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.view addSubview:dismissButton];
    dismissButton.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    dismissButton.backgroundColor = [UIColor whiteColor];
    [dismissButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random() % 255) / 255.0
                           green:(arc4random() % 255) / 255.0
                            blue:(arc4random() % 255) / 255.0
                           alpha:1.0];
}

- (void)onTap:(id)sender {
    ColorViewController *nextColor = [[ColorViewController alloc] initWithColor:[self randomColor]];
    nextColor.transitioningDelegate = self.transitioningDelegate;
    [self presentViewController:nextColor animated:YES completion:nil];
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

@end
