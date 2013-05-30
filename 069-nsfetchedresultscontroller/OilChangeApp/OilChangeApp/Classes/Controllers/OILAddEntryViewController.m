//
//  OILAddEntryViewController.m
//  OilChangeApp
//
//  Created by ben on 5/25/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "OILAddEntryViewController.h"
#import "OILEntry.h"
#import "OILEntry+Custom.h"
#import "OILDataModel.h"

@interface OILAddEntryViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) OILEntry *entry;

@end

@implementation OILAddEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.milesTextField.textEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    
    self.context = [[OILDataModel shareDataModel] buildContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry"
                                              inManagedObjectContext:self.context];
    self.entry = [[OILEntry alloc] initWithEntity:entity
                   insertIntoManagedObjectContext:self.context];
    self.entry.date = [NSDate date];
    self.entry.miles = [self previousMileage];
    [self updateDisplay];
    
}

- (NSNumber *)previousMileage {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setPropertiesToFetch:@[@"miles"]];
    [fetchRequest setSortDescriptors:@[
     [NSSortDescriptor sortDescriptorWithKey:@"miles" ascending:NO]
     ]];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest
                                                   error:&error];
    if ([results count] == 0) {
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
        return 0;
    }
    
    return [results[0] miles];
}

- (void)updateDisplay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.entry.date];
    self.milesTextField.text = [NSString stringWithFormat:@"%@", self.entry.miles];
}

- (IBAction)onCancel:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveChanges {
    [self.entry setMiles:@([self.milesTextField.text intValue])];
    [self.entry setLog:self.logTextView.text];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"ERROR: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Error saving"
                                   message:@"Couldn't save the record :("
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
    }
}

- (IBAction)onSave:(id)sender {
    [self saveChanges];
    [self dismiss];
}

@end
