//
//  BLAddLatteViewController.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/28/12.
//
//

#import "BLAddLatteViewController.h"
#import "BLLatte.h"
#import "BLProgressView.h"

@interface BLAddLatteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BLAddLatteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [self saveButton];
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(save:)];
}

- (void)viewDidUnload {
    [self setLocationTextField:nil];
    [self setAuthorTextField:nil];
    [self setCommentsTextView:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"photoCell"]) {
        [self promptForPhoto];
    }
}

- (void)promptForPhoto {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary |
        UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType |=UIImagePickerControllerSourceTypeCamera;
    }
    
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    [self presentViewController:pickerController
                       animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender {
    BLLatte *latte = [[BLLatte alloc] init];
    latte.location = self.locationTextField.text;
    latte.submittedBy = self.authorTextField.text;
    latte.comments = self.commentsTextView.text;
    latte.photoData = UIImagePNGRepresentation(self.imageView.image);
    
    [self.view endEditing:YES];
    
    BLProgressView *progressView = [BLProgressView presentInWindow:self.view.window];
    
    // save it
    [latte saveWithProgress:^(CGFloat progress) {
        [progressView setProgress:progress];
    } completion:^(BOOL success, NSError *error) {
        [progressView dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

@end
