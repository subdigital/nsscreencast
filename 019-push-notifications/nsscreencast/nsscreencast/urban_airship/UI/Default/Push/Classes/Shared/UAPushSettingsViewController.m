/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UAirship.h"
#import "UAPush.h"
#import "UAPushUI.h"
#import "UAPushSettingsViewController.h"
#import "UALocationService.h"

// Overall counts for sectioned table view
enum {
    SectionPushEnabled = 0,
    SectionAirshipLocationEnabled = 1,
    SectionQuietTime   = 2,
    SectionCount       = 3
};

// The section for the push enabled switch is 0
// The row count for the push table view is 1
enum {
    PushEnabledSectionSwitchCell = 0,
    PushEnabledSectionRowCount   = 1
};

// The section for the Airship is 1
// The row count is one
//static NSUInteger AirshipLocationEnabledSectionSwitchCell = 1;
static NSUInteger AirshipLocationEnabledSectionRowCount = 1;

// Enums for the Quiet time table view
enum {
    QuietTimeSectionSwitchCell  = 0,
    QuietTimeSectionStartCell   = 1,
    QuietTimeSectionEndCell     = 2,
    QuietTimeSectionRowCount    = 3
};

@implementation UAPushSettingsViewController

@synthesize tableView;
@synthesize datePicker;

@synthesize pushEnabledCell;
@synthesize pushEnabledLabel;
@synthesize pushEnabledSwitch;

@synthesize quietTimeEnabledCell;
@synthesize quietTimeLabel;
@synthesize quietTimeSwitch;
@synthesize fromCell;
@synthesize toCell;
@synthesize airshipLocationEnabledSwitch = airshipLocationEnabledSwitch_;
@synthesize airshipLocationEnabledLabel = airshipLocationEnabledLabel_;
@synthesize airshipLocationEnabledCell = airshipLocationEnabledCell_;

#pragma mark -
#pragma mark Lifecycle methods

- (void)dealloc {

    self.pushEnabledSwitch = nil;
    self.pushEnabledLabel = nil;
    self.pushEnabledCell = nil;
    
    self.quietTimeSwitch = nil;
    self.quietTimeLabel = nil;
    self.quietTimeEnabledCell = nil;
    self.toCell = nil;
    self.fromCell = nil;
    
    self.tableView = nil;
    self.datePicker = nil;
    self.airshipLocationEnabledSwitch = nil;
    self.airshipLocationEnabledLabel = nil;
    self.airshipLocationEnabledCell = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {

    self.pushEnabledSwitch = nil;
    self.pushEnabledLabel = nil;
    self.pushEnabledCell = nil;
    
    self.quietTimeSwitch = nil;
    self.quietTimeLabel = nil;
    self.quietTimeEnabledCell = nil;
    self.toCell = nil;
    self.fromCell = nil;
    
    self.tableView = nil;
    self.datePicker = nil;
    self.airshipLocationEnabledSwitch = nil;
    self.airshipLocationEnabledLabel = nil;
    self.airshipLocationEnabledCell = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Hide the picker if it was left up last time
    [self updateDatePicker:NO];
    [super viewWillAppear:animated];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //if shown, update picker and scroll offset
    if (pickerDisplayed) {
        [self updateDatePicker:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (pushEnabledSwitch.on) {
        return SectionCount;
    } else {
        return SectionCount - 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionPushEnabled:
            return PushEnabledSectionRowCount;
        case SectionAirshipLocationEnabled:
            return AirshipLocationEnabledSectionRowCount;
        case SectionQuietTime:
        {
            if (pushEnabledSwitch.on && quietTimeSwitch.on) {
                return QuietTimeSectionRowCount;
            } else if (pushEnabledSwitch.on) {
                return 1;
            }
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionQuietTime) {
        if (indexPath.row == QuietTimeSectionSwitchCell) {
            quietTimeEnabledCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return quietTimeEnabledCell;
        } else if (indexPath.row == QuietTimeSectionStartCell) {
            return fromCell;
        } else {
            return toCell;
        }
    } else if (indexPath.section == SectionPushEnabled) {
        return pushEnabledCell;
    } else if (indexPath.section == SectionAirshipLocationEnabled) {
        return airshipLocationEnabledCell_;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableVieDelegate Methods
- (void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 2) {
        [self updateDatePicker:YES];
    } else {
        [self updateDatePicker:NO];
    }
}

// UA_Push_Settings_Location_Enabled_Label
#pragma mark -
#pragma mark logic

- (void)initViews {
    self.title = UA_PU_TR(@"UA_Push_Settings_Title");
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(quit)]
                                              autorelease];

    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type == UIRemoteNotificationTypeNone || ![UAPush shared].pushEnabled) {
        pushEnabledSwitch.on = NO;
    } else {
        pushEnabledSwitch.on = YES;
    }
    if ([UALocationService airshipLocationServiceEnabled]) {
        airshipLocationEnabledSwitch_.on = YES;
    }
    else {
        airshipLocationEnabledSwitch_.on = NO;
    }
    
    pushEnabledLabel.text = UA_PU_TR(@"UA_Push_Settings_Enabled_Label");
    quietTimeLabel.text = UA_PU_TR(@"UA_Push_Settings_Quiet_Time_Label");
    
    fromCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    toCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    fromCell.textLabel.text = UA_PU_TR(@"UA_Quiet_Time_From");
    toCell.textLabel.text = UA_PU_TR(@"UA_Quiet_Time_To");

    
    NSDate *date1 = nil;
    NSDate *date2 = nil;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    
    
    NSDictionary *quietTime = [[NSUserDefaults standardUserDefaults] objectForKey:kQuietTime];
    [formatter setDateFormat:@"HH:mm"];
    if (quietTime != nil) {
        UALOG(@"Quiet time dict found: %@ to %@", [quietTime objectForKey:@"start"], [quietTime objectForKey:@"end"]);
        quietTimeSwitch.on = YES;
        date1 = [formatter dateFromString:[quietTime objectForKey:@"start"]];
        date2 = [formatter dateFromString:[quietTime objectForKey:@"end"]];
    }
    
    if (date1 == nil || date2 == nil) {
        quietTimeSwitch.on = NO;
        date1 = [formatter dateFromString:@"22:00"];//default start
        date2 = [formatter dateFromString:@"07:00"];//default end //TODO: make defaults parameters
    }

    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    fromCell.detailTextLabel.text = [formatter stringFromDate:date1];
    toCell.detailTextLabel.text = [formatter stringFromDate:date2];

    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:NO];
    [now release];

    pickerDisplayed = NO;
    pickerShownFrame = CGRectZero;
    pickerHiddenFrame = CGRectZero;
    
    [self.view setNeedsLayout];
}

- (void)updatePickerLayout {
    
    CGRect viewBounds = self.view.bounds;
    
IF_IOS4_OR_GREATER (
    
    //Manually set the size of the picker for better landscape experience
    //Older  devies do not like the custom size. It breaks the picker.
                    
    //If the picker is in a portrait container, use std portrait picker dims
    if (viewBounds.size.height >= viewBounds.size.width) {
        datePicker.bounds = CGRectMake(0, 0, 320, 216);
    } else {
        datePicker.bounds = CGRectMake(0, 0, 480, 162);
    }
    
    // reset picker subviews
    for (UIView* subview in datePicker.subviews) {
        subview.frame = datePicker.bounds;
    }
                    );
    
    // reset the visible/hidden views
    int viewOffset = self.view.frame.origin.y;
    CGRect pickerBounds = datePicker.bounds;
    pickerShownFrame = CGRectMake(0, viewOffset+viewBounds.size.height-pickerBounds.size.height,
                                  viewBounds.size.width, pickerBounds.size.height);
    pickerHiddenFrame = CGRectMake(0, viewOffset+viewBounds.size.height,
                                   viewBounds.size.width, pickerBounds.size.height);
    
    //reset actual frame
    if (pickerDisplayed) {
        datePicker.frame = pickerShownFrame;
    } else {
        datePicker.frame = pickerHiddenFrame;
    }
}

- (IBAction)quit {
    
    if (dirty) {
        
        [UAPush shared].pushEnabled = pushEnabledSwitch.on;
        
        if (pushEnabledSwitch.on) {
            [self updateQuietTime];
        } else {
            [[UAPush shared] updateRegistration];
        }
        dirty = NO;
    }
    
    [UAPush closeApnsSettingsAnimated:YES];
}

- (IBAction)pickerValueChanged:(id)sender {

    dirty = YES;
    
    NSDate *date = [datePicker date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    int row = [[self.tableView indexPathForSelectedRow] row];
    if (row == QuietTimeSectionStartCell) {
        fromCell.detailTextLabel.text = [formatter stringFromDate:date];
        [fromCell setNeedsLayout];
    } else if (row == QuietTimeSectionEndCell) {
        toCell.detailTextLabel.text = [formatter stringFromDate:date];
        [toCell setNeedsLayout];
    } else {
        NSDate *now = [[NSDate alloc] init];
        [datePicker setDate:now animated:YES];
        [now release];
        return;
    }

}

- (IBAction)switchValueChanged:(id)sender {
    
    dirty = YES;
    
    if (!quietTimeSwitch.on || !pushEnabledSwitch.on) {
        [self updateDatePicker:NO];
    }
    [self.tableView reloadData];
    
    if (airshipLocationEnabledSwitch_.on){
        [UALocationService setAirshipLocationServiceEnabled:YES];
    }
    else {
        [UALocationService setAirshipLocationServiceEnabled:NO];
    }

}

- (void)updateDatePicker:(BOOL)show {
    
    [self updatePickerLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    if (show) {
        [self.view addSubview:datePicker];
        pickerDisplayed = YES;
        datePicker.frame = pickerShownFrame;
        
        //Scroll the table view so the "To" field is just above the top of the data picker
        int scrollOffset = MAX(0, 
                               toCell.frame.origin.y
                               + toCell.frame.size.height
                               + tableView.sectionFooterHeight
                               - datePicker.frame.origin.y);
        tableView.contentOffset = CGPointMake(0, scrollOffset);
    } else {
        pickerDisplayed = NO;
        tableView.contentOffset = CGPointZero;//reset scroll offset
        datePicker.frame = pickerHiddenFrame;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    }
    [UIView commitAnimations];
    
    //remove picker display after animation
    if (!pickerDisplayed) {
        [datePicker removeFromSuperview];
    }

    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *fromString = fromCell.detailTextLabel.text;
    NSString *toString = toCell.detailTextLabel.text;

    int row = [[self.tableView indexPathForSelectedRow] row];
    if (row == 1 && [fromString length] != 0) {
        NSDate *fromDate = [formatter dateFromString:fromString];
        [datePicker setDate:fromDate animated:YES];
    } else if (row == 2 && [toString length] != 0) {
        NSDate *toDate = [formatter dateFromString:toString];
        [datePicker setDate:toDate animated:YES];
    }
}

- (void)updateQuietTime {
    
    if (quietTimeSwitch.on) {
        
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *fromString = fromCell.detailTextLabel.text;
        NSString *toString = toCell.detailTextLabel.text;
        NSDate *fromDate = [formatter dateFromString:fromString];
        NSDate *toDate = [formatter dateFromString:toString];
        
        UALOG(@"Start String: %@", fromString);
        UALOG(@"End String: %@", toString);
        
        [[UAPush shared] setQuietTimeFrom:fromDate to:toDate withTimeZone:[NSTimeZone localTimeZone]];
    } else {
        [[UAPush shared] disableQuietTime];
    }
    

}

@end
