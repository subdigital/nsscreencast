//
//  ViewController.h
//  CocoaPodsSample
//
//  Created by Ben Scheirman on 2/12/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textView;

- (IBAction)fetchGoogleTapped:(id)sender;

@end
