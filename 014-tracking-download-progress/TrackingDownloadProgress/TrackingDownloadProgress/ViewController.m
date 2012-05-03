//
//  ViewController.m
//  TrackingDownloadProgress
//
//  Created by Ben Scheirman on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize progressView;
@synthesize progressLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView.progress = 0;
    self.progressView.alpha = 0;    
    self.progressLabel.text = @"";
}

- (void)viewDidUnload {
    [self setProgressView:nil];
    [self setProgressLabel:nil];
    [super viewDidUnload];    
}

- (void)presentPlayerWithURL:(NSURL *)url {
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:mpvc];
}

- (IBAction)downloadTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.mediacollege.com/downloads/video/hd/shuttle-flip.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op;
    op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSString *targetFilename = [url lastPathComponent];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:targetFilename];
    
    [op setResponseFilePath:targetPath];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self presentPlayerWithURL:[NSURL fileURLWithPath:targetPath]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure case
    }];

    
    [op setDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesExpectedToRead > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.alpha = 1;
                self.progressView.progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
                NSString *label = [NSString stringWithFormat:@"Downloaded %lld of %lld bytes", 
                                   totalBytesRead,
                                   totalBytesExpectedToRead];
                self.progressLabel.text = label;
            });
        }
    }];
    [op start];
}

@end
