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
    
    NSData *imageData = UIImagePNGRepresentation(_image);
    self.imageFile = [PFFile fileWithData:imageData];
    [self.imageFile saveInBackground];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setCaptionField:nil];
    [super viewDidUnload];
}

- (IBAction)uploadPhoto:(id)sender {
    NSString *caption = self.captionField.text;
    PFObject *photo = [[PFObject alloc] initWithClassName:@"Photo"];
    [photo setObject:caption forKey:@"caption"];
    [photo setObject:self.imageFile forKey:@"photo"];
    
    [SVProgressHUD show];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FGPhotoUploaded"
                                                                object:self];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"ERROR: %@", error);
            [SVProgressHUD dismissWithError:@"ERROR"];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
