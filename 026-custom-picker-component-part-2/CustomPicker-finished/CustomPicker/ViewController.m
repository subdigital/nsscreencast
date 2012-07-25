//
//  ViewController.m
//  CustomPicker
//
//  Created by Ben Scheirman on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "BSModalPickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) NSArray *items;

@end

@implementation ViewController

@synthesize messageLabel = _messageLabel;
@synthesize items = _items;

- (IBAction)choose:(id)sender {
    BSModalPickerView *pickerView = [[BSModalPickerView alloc] initWithValues:self.items];
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
        NSLog(@"Made choice? %d", madeChoice);
        NSLog(@"Selected value: %@", pickerView.selectedValue);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", nil];
}

- (void)viewDidUnload {
    [self setMessageLabel:nil];
    [super viewDidUnload];
}

@end
