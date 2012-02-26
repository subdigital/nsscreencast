//
//  ViewController.m
//  CocoaPodsSample
//
//  Created by Ben Scheirman on 2/12/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation ViewController

@synthesize textView = _textView;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

- (IBAction)fetchGoogleTapped:(id)sender {
    [SVProgressHUD show];
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismissWithSuccess:@"Done!" afterDelay:1.0f];
        self.textView.text = operation.responseString;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", operation.responseString);
        [SVProgressHUD dismissWithError:@"Error!" afterDelay:1.0f];
    }];
    [operation start];
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
@end
