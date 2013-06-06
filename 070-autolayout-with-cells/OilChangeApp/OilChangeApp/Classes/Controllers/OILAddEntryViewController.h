//
//  OILAddEntryViewController.h
//  OilChangeApp
//
//  Created by ben on 5/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSTextField.h>

@interface OILAddEntryViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet SSTextField *milesTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

- (IBAction)onSave:(id)sender;

@end
