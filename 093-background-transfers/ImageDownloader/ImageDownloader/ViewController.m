//
//  ViewController.m
//  ImageDownloader
//
//  Created by ben on 10/28/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIActionSheetDelegate, NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) void (^backgroundCompletionHandler)(void);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView.hidden = YES;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(promptForDelete:)];
    [self.view addGestureRecognizer:longPress];

    if ([self localImageExists]) {
        [self loadImage];
    }
}

- (BOOL)localImageExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self localImagePath]];
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.ficklebits.imageDownloader.wallpaper"];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:nil];
    }
    return _session;
}

- (IBAction)downloadTapped:(id)sender {
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    NSURL *imageUrl = [NSURL URLWithString:
                       @"http://imgsrc.hubblesite.org/hu/db/images/hs-2006-14-a-2560x1024_wallpaper.jpg"
                       //@"http://m3.i.pbase.com/o2/81/503681/1/117923023.NptXUbnx.FdaysKTI2725.jpg"
                       ];

    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:imageUrl];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [task resume];
}

- (NSString *)localImagePath {
    NSString *docsDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *targetPath = [docsDir stringByAppendingPathComponent:@"image.jpg"];
    return targetPath;
}

- (void)loadImage {
    UIImage *image = [UIImage imageWithContentsOfFile:[self localImagePath]];
    self.imageView.image = image;
}

- (void)promptForDelete:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (![self localImageExists]) {
            return;
        }
        
        [[[UIActionSheet alloc] initWithTitle:@"Delete image?"
                                     delegate:self
                            cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:@"Yes, Delete"
                            otherButtonTitles:nil] showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [self deleteLocalImage];
    }
}

- (void)deleteLocalImage {
    self.imageView.image = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self localImagePath]
                                               error:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBackgroundSession:)
                                                 name:@"BackgroundSessionUpdated"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleBackgroundSession:(NSNotification *)notification {
    if ([notification.userInfo[@"sessionIdentifier"] isEqualToString:self.session.configuration.identifier]) {
        self.backgroundCompletionHandler = notification.userInfo[@"completionHandler"];
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (self.backgroundCompletionHandler) {
        self.backgroundCompletionHandler();
        self.backgroundCompletionHandler = nil;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSError *fileError;
    
    if ([[NSFileManager defaultManager] copyItemAtURL:location
                                                toURL:[NSURL fileURLWithPath:[self localImagePath]]
                                                error:&fileError]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadImage];
            self.progressView.hidden = YES;
        });
        
        
    } else {
        NSLog(@"Copy file error: %@", fileError);
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"Progress: %.2f", progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
}




@end
