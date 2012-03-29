//
//  AddBookmarkViewController.m
//  Bookmarks
//
//  Created by Ben Scheirman on 3/11/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "AddBookmarkViewController.h"

@interface AddBookmarkViewController ()

@end

@implementation AddBookmarkViewController

@synthesize delegate = _delegate;
@synthesize labelTextField = _labelTextField;
@synthesize urlTextField = _urlTextField;

- (id)init {
    self = [super initWithNibName:@"AddBookmarkViewController" bundle:nil];
    if (self) {
    }
    return self;
}


- (UIBarButtonItem *)cancelButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self 
                                                          action:@selector(onCancel:)];
}

- (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                          target:self
                                                          action:@selector(onSave:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add a Bookmark";
    
    self.navigationItem.leftBarButtonItem = [self cancelButton];
    self.navigationItem.rightBarButtonItem = [self saveButton];
    
    [self.labelTextField becomeFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    self.labelTextField = nil;
    self.urlTextField = nil;
}

- (void)onSave:(id)sender {
    NSString *label = self.labelTextField.text;
    NSString *url = self.urlTextField.text;
    
    if ([label length] == 0 || [url length] == 0) {
        return;
    }
    
    [self.delegate addBookmarkViewController:self
                    didSaveBookmarkWithLabel:self.labelTextField.text
                                         url:self.urlTextField.text];
}

- (void)onCancel:(id)sender {
    [self.delegate addBookmarkViewControllerDidCancel:self];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.labelTextField) {
        [self.urlTextField becomeFirstResponder];
    } else {
        [self onSave:textField];
    }
    return NO;
}

@end
