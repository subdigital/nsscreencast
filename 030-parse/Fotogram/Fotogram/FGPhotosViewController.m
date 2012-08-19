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

@interface UIImageView (ParseFileSupport)
- (void)setFile:(PFFile *)file;
@end

@implementation UIImageView (ParseFileSupport)
- (void)setFile:(PFFile *)file {
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            self.image = [UIImage imageWithData:data];
            [self setNeedsDisplay];
        } else {
            NSLog(@"Error:%@", error);
        }

    }];
}
@end

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
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        image = [image imageCroppedToFitSize:CGSizeMake(250, 250)];
        FGImagePreviewViewController *previewController = [[FGImagePreviewViewController alloc] initWithImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:previewController animated:YES];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:0.7 green:0.5 blue:0.3 alpha:1.0];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    NSString *caption = [object objectForKey:@"caption"];
    PFFile *imageFile = [object objectForKey:@"photo"];
    cell.textLabel.text = caption;
    cell.imageView.file = imageFile;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)onPhotoUploaded:(NSNotification *)notification {
    [self loadObjects];
}

@end
