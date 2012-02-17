//
//  NewEventViewController.m
//  libPusher
//
//  Created by Luke Redpath on 23/04/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NewEventViewController.h"
#import "PusherEventsViewController.h"

@implementation NewEventViewController

@synthesize textView;
@synthesize delegate;

- (id)init;
{
  return [self initWithNibName:@"NewEventViewController" bundle:nil];
}

- (void)dealloc 
{
  [textView release];
  [super dealloc];
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  
  [self.textView becomeFirstResponder];
}

- (void)viewDidUnload 
{
  [super viewDidUnload];
  
  self.textView = nil;
}

#pragma mark -
#pragma mark Actions

- (IBAction)sendEvent:(id)sender;
{
  [self.delegate sendEventWithMessage:self.textView.text];
}

- (IBAction)cancel:(id)sender 
{
  [self dismissModalViewControllerAnimated:YES];
}

@end
