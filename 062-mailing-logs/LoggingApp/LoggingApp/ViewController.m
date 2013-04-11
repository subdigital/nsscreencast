//
//  ViewController.m
//  LoggingApp
//
//  Created by ben on 3/31/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import "SSZipArchive.h"

@interface ViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewController - viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ViewController - didReceiveMemoryWarning");
}

- (IBAction)doSomething:(id)sender {
    NSLog(@"doing something...");
}

- (IBAction)doSomethingElse:(id)sender {
    NSLog(@"doing something ELSE...");
}

- (IBAction)generate500Numbers:(id)sender {
    
    for (int i=0; i<500; i++) {
        int randomNumber = arc4random() % 1000;
        NSLog(@"Generated %d", randomNumber);
    }
}

- (NSString *)cachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)logsDirectory {
    return [[self cachesDirectory] stringByAppendingPathComponent:@"Logs"];
}

- (NSData *)zipLogs {
    NSString *logsDir = [self logsDirectory];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logsDir error:nil];
    NSPredicate *textFilePredicate = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
    files = [files filteredArrayUsingPredicate:textFilePredicate];
    
    NSString *logZipPath = [logsDir stringByAppendingPathComponent:@"logs.zip"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logZipPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:logZipPath error:nil];
    }
    
    NSMutableArray *inputFiles = [NSMutableArray array];
    for (NSString *file in files) {
        [inputFiles addObject:[logsDir stringByAppendingPathComponent:file]];
    }
    
    [SSZipArchive createZipFileAtPath:logZipPath withFilesAtPaths:inputFiles];
    NSData *zipData = [NSData dataWithContentsOfFile:logZipPath];
    [[NSFileManager defaultManager] removeItemAtPath:logZipPath error:nil];
    return zipData;
}

- (IBAction)mailLogs:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        [[[UIAlertView alloc] initWithTitle:@"Can't send email"
                                    message:@"Please set up your mail account first"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *zipFileData = [self zipLogs];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            [mailVC setSubject:@"Application Logs"];
            [mailVC setToRecipients:@[@"ben@scheirman.com"]];
            [mailVC setMessageBody:@"Please find the attached logs" isHTML:NO];
            [mailVC addAttachmentData:zipFileData
                             mimeType:@"application/zip"
                             fileName:@"logs.zip"];
            
            [mailVC setMailComposeDelegate:self];
            
            [self presentViewController:mailVC animated:YES completion:nil];
        });
    });

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSaved:
            NSLog(@"Saved as a draft");
            break;
            
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail send failed");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
