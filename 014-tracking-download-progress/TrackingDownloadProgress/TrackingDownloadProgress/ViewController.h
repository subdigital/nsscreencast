//
//  ViewController.h
//  TrackingDownloadProgress
//
//  Created by Ben Scheirman on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (IBAction)downloadTapped:(id)sender;

@end
