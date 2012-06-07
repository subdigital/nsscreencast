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

#import "UAPushMoreSettingsViewController.h"
#import "UAirship.h"
#import "UAViewUtils.h"
#import "UAPush.h"
#import "UAPushSettingsTokenViewController.h"
#import "UAPushSettingsAliasViewController.h"
#import "UAPushSettingsTagsViewController.h"
#import "UAPushSettingsSoundsViewController.h"
#import "UALocationSettingsViewController.h"

enum {
    SectionDeviceToken = 0,
    SectionHelp        = 1,
    SectionLocation    = 2,
    SectionCount       = 3
};

enum {
    DeviceTokenSectionTypesCell = 0,
    DeviceTokenSectionDisabledTypesCell = 1,
    DeviceTokenSectionTokenCell = 2,
    DeviceTokenSectionAliasCell = 3,
    DeviceTokenSectionTagsCell  = 4,
    DeviceTokenSectionRowCount  = 5
};

enum {
    HelpSectionSounds   = 0,
    //HelpSectionLog = 1,
    HelpSectionRowCount = 1
};

static NSUInteger locationRowCount = 1;

@implementation UAPushMoreSettingsViewController

@synthesize footerImageView;
@synthesize tableView;
@synthesize locationCell = locationCell_;

- (void)dealloc {
    [[UAirship shared] removeObserver:self];

    RELEASE_SAFELY(deviceTokenCell);
    RELEASE_SAFELY(deviceTokenTypesCell);
    RELEASE_SAFELY(deviceTokenDisabledTypesCell);
    RELEASE_SAFELY(deviceTokenAliasCell);
    RELEASE_SAFELY(deviceTokenTagsCell);
    RELEASE_SAFELY(helpSoundsCell);
    RELEASE_SAFELY(helpLogCell);
    
    self.footerImageView = nil;
    self.tableView = nil;
    
    RELEASE_SAFELY(tokenViewController);
    RELEASE_SAFELY(aliasViewController);
    RELEASE_SAFELY(tagsViewController);
    RELEASE_SAFELY(locationCell_)
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Push Notification Demo";

    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:@"Back"
                                              style:UIBarButtonItemStyleBordered
                                              target:nil
                                              action:nil]
                                             autorelease];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self
                                              action:@selector(quit)]
                                             autorelease];

    [self initCells];

    [UAViewUtils roundView:footerImageView borderRadius:10
               borderWidth:1 color:[UIColor lightGrayColor]];
    [[UAirship shared] addObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self updateCellValues];
    
    [self.tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [tableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    RELEASE_SAFELY(deviceTokenCell);
    RELEASE_SAFELY(deviceTokenTypesCell);
    RELEASE_SAFELY(deviceTokenDisabledTypesCell);
    RELEASE_SAFELY(deviceTokenAliasCell);
    RELEASE_SAFELY(deviceTokenTagsCell);
    RELEASE_SAFELY(helpSoundsCell);
    RELEASE_SAFELY(helpLogCell);
    RELEASE_SAFELY(locationCell_);
    
    self.footerImageView = nil;
    self.tableView = nil;
    
}

#pragma mark -

- (void)initCells {
    deviceTokenCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    deviceTokenCell.textLabel.text = @"Device Token";
    deviceTokenCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    deviceTokenTypesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    deviceTokenTypesCell.textLabel.text = @"Notification Types";

    deviceTokenDisabledTypesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    deviceTokenDisabledTypesCell.textLabel.text = @"Disabled Notification Types";
    
    deviceTokenAliasCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    deviceTokenAliasCell.textLabel.text = @"Alias";
    deviceTokenAliasCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    deviceTokenTagsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    deviceTokenTagsCell.textLabel.text = @"Tags";
    deviceTokenTagsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    helpSoundsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    helpSoundsCell.textLabel.text = @"Notification Sounds";
    helpSoundsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    helpLogCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    helpLogCell.textLabel.text = @"Device Log";
    helpLogCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.locationCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    locationCell_.textLabel.text = @"Location";
    
    [self updateCellValues];
}

- (void)quit {
    [UAPush closeTokenSettingsAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionDeviceToken:
            return DeviceTokenSectionRowCount;
        case SectionHelp:
            return HelpSectionRowCount;
        case SectionLocation:
            return locationRowCount;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SectionDeviceToken:
            return @"Token Settings";
        case SectionHelp:
            return @"Bundle Info";
        case SectionLocation:
            return @"Location";
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == SectionDeviceToken) {
        
        switch (indexPath.row) {
            case DeviceTokenSectionTokenCell:
                cell = deviceTokenCell;
                break;
            case DeviceTokenSectionTypesCell:
                cell = deviceTokenTypesCell;
                break;
            case DeviceTokenSectionDisabledTypesCell:
                cell = deviceTokenDisabledTypesCell;
                break;
            case DeviceTokenSectionAliasCell:
                cell = deviceTokenAliasCell;
                break;
            case DeviceTokenSectionTagsCell:
                cell = deviceTokenTagsCell;
                break;
            default:
                break;
        }
        
    } else if (indexPath.section == SectionHelp) {

        if (indexPath.row == HelpSectionSounds) {
            cell = helpSoundsCell;
        } 
        
    } else if (indexPath.section == SectionLocation) {
        cell = locationCell_;
    }

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 55 : 44;
}

- (void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionDeviceToken) {
        if (indexPath.row == DeviceTokenSectionTokenCell) {
            if (!tokenViewController) {
                tokenViewController = [[UAPushSettingsTokenViewController alloc]
                                       initWithNibName:@"UAPushSettingsTokenView" bundle:nil];
            }
            [self.navigationController pushViewController:tokenViewController animated:YES];
        } else if (indexPath.row == DeviceTokenSectionAliasCell) {
            if (!aliasViewController) {
                aliasViewController = [[UAPushSettingsAliasViewController alloc]
                                       initWithNibName:@"UAPushSettingsAliasView" bundle:nil];
            }
            [self.navigationController pushViewController:aliasViewController animated:YES];
            
        } else if (indexPath.row == DeviceTokenSectionTagsCell) {
            if (!tagsViewController) {
                tagsViewController = [[UAPushSettingsTagsViewController alloc] 
                                      initWithNibName:@"UAPushSettingsTagsViewController" bundle:nil];
            }
            [self.navigationController pushViewController:tagsViewController animated:YES];
            
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (indexPath.section == SectionHelp) {
        if (indexPath.row == HelpSectionSounds) {
            UAPushSettingsSoundsViewController *soundsViewController = [[[UAPushSettingsSoundsViewController alloc] 
                                                                         initWithNibName:@"UAPushSettingsSoundsViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:soundsViewController animated:YES];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        

    } else if(indexPath.section == SectionLocation) {
        UALocationSettingsViewController* locationViewController = [[[UALocationSettingsViewController alloc] 
                                                                     initWithNibName:@"UALocationSettingsViewController" 
                                                                     bundle:nil] autorelease];
        [self.navigationController pushViewController:locationViewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}

#pragma mark -
#pragma mark UA Registration Observer methods

- (void)registerDeviceTokenSucceed {
    
    [self updateCellValues];
    
    [deviceTokenCell setNeedsLayout];
    [deviceTokenTypesCell setNeedsLayout];
    [deviceTokenDisabledTypesCell setNeedsLayout];
    [deviceTokenAliasCell setNeedsLayout];
    [deviceTokenTagsCell setNeedsLayout];
}

- (void)updateCellValues {
    
    deviceTokenCell.detailTextLabel.text = [UAirship shared].deviceToken ? [UAirship shared].deviceToken : @"Unavailable";
    deviceTokenTypesCell.detailTextLabel.text = [UAPush pushTypeString:[[UIApplication sharedApplication] enabledRemoteNotificationTypes]];
    
    UIRemoteNotificationType disabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ^ [UAPush shared].notificationTypes;
    deviceTokenDisabledTypesCell.detailTextLabel.text = [UAPush pushTypeString:disabledTypes];
    
    deviceTokenAliasCell.detailTextLabel.text = [UAPush shared].alias ? [UAPush shared].alias : @"Not Set";
    
    if ([[UAPush shared].tags count] > 0) {
        deviceTokenTagsCell.detailTextLabel.text = [[UAPush shared].tags componentsJoinedByString:@", "];
    } else {
        deviceTokenTagsCell.detailTextLabel.text = @"None";
    }
}

@end
