//
//  ShareViewController.m
//  ImgShareExtension
//
//  Created by Ben Scheirman on 11/7/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ShareViewController.h"
@import MobileCoreServices;
@import ImgShareKit;

@interface ShareViewController ()

@property (nonatomic, strong) NSURL *imageURL;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)presentationAnimationDidFinish {
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *provider in item.attachments) {
            NSString *imageType = (NSString *)kUTTypeImage;
            if ([provider hasItemConformingToTypeIdentifier:imageType]) {
                [provider loadItemForTypeIdentifier:imageType
                                            options:nil
                                  completionHandler:^(NSURL *imageURL, NSError *error) {
                                      if (error) {
                                          NSLog(@"ERROR: %@", error);
                                      } else {
                                          NSLog(@"Got image url: %@", imageURL);
                                          self.imageURL = imageURL;
                                          return;
                                      }
                                  }];
            }
        }
    }
}

- (BOOL)isContentValid {
    return (self.imageURL != nil && self.contentText.length > 0);
}

- (void)didSelectPost {
    
    [[ImgurApi sharedApi] uploadImageAtURL:self.imageURL
                                 withTitle:self.contentText
                                completion:^(BOOL success, NSError *error) {
                                    UIAlertController *alert = [[UIAlertController alloc] init];
                                    if (success) {
                                        alert.title = @"Image uploaded!";
                                    } else {
                                        alert.title = @"Error uploading image :(";
                                    }
                                    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                              style:UIAlertActionStyleCancel
                                                                            handler:nil]];
                                    [self presentViewController:alert animated:YES
                                                     completion:nil];
                                }];
    
    NSLog(@"Do upload...");
    
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
