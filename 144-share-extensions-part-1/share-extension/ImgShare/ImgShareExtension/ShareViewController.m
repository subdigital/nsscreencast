//
//  ShareViewController.m
//  ImgShareExtension
//
//  Created by Ben Scheirman on 11/7/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ShareViewController.h"
@import MobileCoreServices;

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
    NSLog(@"Do upload...");
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
