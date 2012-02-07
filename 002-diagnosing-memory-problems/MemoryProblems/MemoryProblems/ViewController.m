//
//  ViewController.m
//  MemoryProblems
//
//  Created by Ben Scheirman on 2/5/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (IBAction)createTheDate:(id)sender {
    NSLog(@"Creating the date");
    [_date release];
    _date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
}

- (IBAction)releaseTheDate:(id)sender {
    NSLog(@"Releasing the date");
    [_date release];
    _date = nil;
}

- (IBAction)sendAMessageToTheDate:(id)sender {
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    NSString *localizedDescription = [_date descriptionWithLocale:usLocale];
    NSLog(@"The localized description is: %@", localizedDescription);
    [usLocale release];
}

- (void)dealloc {
    [_date release];
    [super dealloc];
}

@end