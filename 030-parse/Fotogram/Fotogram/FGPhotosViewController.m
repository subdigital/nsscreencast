//
//  FGPhotosViewController.m
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "FGPhotosViewController.h"
#import "FGImagePreviewViewController.h"
#import "NSObject+SubscriptSupport.h"
#import "UIImage+ProportionalFill.h"
#import "UIImageView+ParseFileSupport.h"

@interface FGPhotosViewController ()

@end

@implementation FGPhotosViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain className:@"Photo"];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.objectsPerPage = 30;
    }
    return self;
}

- (UIBarButtonItem *)addPhotoButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(addPhoto:)];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"Fotogram";
    self.navigationItem.rightBarButtonItem = [self addPhotoButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPhotoUploaded:)
                                                 name:@"FGPhotoUploaded"
                                               object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addPhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType |= UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^{ 
                     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        UIImage *thumbnail = [originalImage imageCroppedToFitSize:CGSizeMake(250, 250)];
        FGImagePreviewViewController *imagePreviewController = [[FGImagePreviewViewController alloc] initWithImage:thumbnail];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:imagePreviewController animated:YES];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:0.7 green:0.5 blue:0.3 alpha:1.0];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    cell.textLabel.text = [object objectForKey:@"caption"];
    cell.imageView.file = [object objectForKey:@"photo"];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)onPhotoUploaded:(NSNotification *)notification {
    [self loadObjects];
}

@end
