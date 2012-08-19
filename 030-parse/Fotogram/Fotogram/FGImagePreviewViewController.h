//
//  FGImagePreviewViewController.h
//  Fotogram
//
//  Created by Ben Scheirman on 8/19/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGImagePreviewViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

- (IBAction)uploadPhoto:(id)sender;

- (id)initWithImage:(UIImage *)image;

@end
