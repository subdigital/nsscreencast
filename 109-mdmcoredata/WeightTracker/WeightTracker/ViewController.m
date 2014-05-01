//
//  ViewController.m
//  WeightTracker
//
//  Created by Ben Scheirman on 2/16/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ViewController.h"
#import "RecordWeightViewController.h"
#import "WeightEntriesViewController.h"
#import "WTWeightLog.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTakenLabel;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // load last saved weight
    [self loadLastWeight];
}

- (void)loadLastWeight {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[WTWeightLog MDMCoreDataAdditionsEntityName]];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"dateTaken" ascending:NO] ];
    fetchRequest.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Couldn't fetch last weight: %@", [error localizedDescription]);
    } else {
        WTWeightLog *lastWeight = [results firstObject];
        if (lastWeight) {
            [self updateForWeight:lastWeight];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"flipToEntriesSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        WeightEntriesViewController *entriesVC = [nav viewControllers][0];
        entriesVC.persistenceController = self.persistenceController;
    }
}

- (IBAction)unwindFromLog:(UIStoryboardSegue *)logSegue {
}

- (IBAction)unwindFromRecordWeight:(UIStoryboardSegue *)recordWeightSegue {
    RecordWeightViewController *recordVC = recordWeightSegue.sourceViewController;
    if ([recordVC didSaveWeight]) {
        CGFloat weight = [recordVC.weightTextField.text floatValue];
        if (weight > 0) {
            NSLog(@"Save weight...");
            [self saveWeight:weight];
        } else {
            NSLog(@"Skipping, weight was 0");
        }
    }
}

- (void)saveWeight:(CGFloat)weight {
    
    WTWeightLog *log = [WTWeightLog MDMCoreDataAdditionsInsertNewObjectIntoContext:self.persistenceController.managedObjectContext];
    log.dateTaken = [NSDate date];
    log.units = @"lbs";
    log.weight = @(weight);
    
    [self updateForWeight:log];
    
    [self.persistenceController saveContextAndWait:NO completion:^(NSError *error) {
        if (error) {
            NSLog(@"ERROR:%@", [error localizedDescription]);
        }
    }];
}

- (void)updateForWeight:(WTWeightLog *)log {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    self.dateTakenLabel.text = [formatter stringFromDate:log.dateTaken];
    self.unitLabel.text = log.units;
    self.weightLabel.text = [NSString stringWithFormat:@"%@", log.weight];
}


@end
