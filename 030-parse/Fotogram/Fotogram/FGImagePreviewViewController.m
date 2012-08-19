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
    PFObject *photo = [[PFObject alloc] initWithClassName:@"Photo"];
    [photo setObject:self.captionField.text
              forKey:@"caption"];
    
    [photo setObject:self.imageFile forKey:@"photo"];
    
    [SVProgressHUD showWithStatus:@"Uploading..."];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismissWithSuccess:@"Done"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FGPhotoUploaded"
                                                                object:self];
        } else {
            [SVProgressHUD dismissWithError:
             [NSString stringWithFormat:@"Error: %@", [error localizedDescription]]
                                 afterDelay:2.0];
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textField editing");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
