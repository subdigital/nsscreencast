//
//  BLAddLatteViewController.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLAddLatteViewController.h"
#import "BLLatte.h"
#import "BLProgressView.h"

@interface BLAddLatteViewController ()

@end

@implementation BLAddLatteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Submit Your Latte";
    self.navigationItem.leftBarButtonItem = [self cancelButton];
    self.navigationItem.rightBarButtonItem = [self saveButton];
}

- (void)viewDidUnload {
    [self setLocationTextField:nil];
    [self setNameTextField:nil];
    [self setCommentsTextView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (UIBarButtonItem *)cancelButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                         target:self
                                                         action:@selector(cancel:)];
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(save:)];    
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (UIResponder *)findFirstResponder {
    if ([self.locationTextField isFirstResponder]) {
        return self.locationTextField;
    }
    
    if ([self.nameTextField isFirstResponder]) {
        return self.nameTextField;
    }
    
    if ([self.commentsTextView isFirstResponder]) {
        return self.commentsTextView;
    }
    
    return nil;
}

- (void)save:(id)sender {
    [[self findFirstResponder] resignFirstResponder];
    
    BLLatte *latte = [[BLLatte alloc] init];
    latte.location = self.locationTextField.text;
    latte.submittedBy = self.nameTextField.text;
    latte.comments = self.commentsTextView.text;
    
    if (self.imageView.image) {
        latte.photoData = UIImagePNGRepresentation(self.imageView.image);        
    }
    
    BLProgressView *progressView = [BLProgressView presentInWindow:self.view.window];
    [latte saveWithProgress:^(CGFloat progress) {
        progressView.progress = progress;
    } completion:^(BOOL success, NSError *error) {
        [progressView dismiss];
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"ERROR"
                                        message:@"Couldn't save the latte"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"photoCell"]) {
        [self promptForPhoto];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)promptForPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum | UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType |= UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES completion:^{   
                       }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
