//
//  FGImagePreviewViewController.m
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "FGImagePreviewViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface FGImagePreviewViewController () {
    UIImage *_image;
}

@property PFFile *imageFile;

@end

@implementation FGImagePreviewViewController

- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:@"FGImagePreviewViewController" bundle:nil];
    if (self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = _image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setCaptionField:nil];
    [super viewDidUnload];
}

- (IBAction)uploadPhoto:(id)sender {
    // TODO:
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
