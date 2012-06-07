/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
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

#import "UASubscriptionContentsViewController.h"
#import "UAGlobal.h"
#import "UASubscriptionManager.h"
#import "UASubscriptionInventory.h"
#import "UASubscription.h"
#import "UASubscriptionContent.h"
#import "UASubscriptionContentDetailViewController.h"
#import "UAAsycImageView.h"
#import "UAViewUtils.h"
#import "UASubscriptionUI.h"


@implementation UASubscriptionContentsViewController
@synthesize contentsTable;
@synthesize subscriptionKey;

#pragma mark lifecyle methods

- (void)dealloc {
    RELEASE_SAFELY(subscriptionKey);
    RELEASE_SAFELY(contentsTable);
    RELEASE_SAFELY(downloadedContents);
    RELEASE_SAFELY(undownloadedContents);
    RELEASE_SAFELY(detailViewController);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[UASubscriptionManager shared] addObserver:self];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)setSubscriptionKey:(NSString *)value {
    if (subscriptionKey == value) {
        return;
    }
    [value retain];
    [subscriptionKey release];
    subscriptionKey = value;

    [self updateDataSource];
}

- (void)updateDataSource {
    UASubscription *subscription = [[UASubscriptionManager shared].inventory subscriptionForKey:subscriptionKey];
    downloadedContents = subscription.downloadedContents;
    undownloadedContents = subscription.undownloadedContents;

    [contentsTable reloadData];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((section == 0) && (undownloadedContents.count > 0)) {
        return undownloadedContents.count;
    } else {
        return downloadedContents.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
    if (downloadedContents.count > 0) count ++;
    if (undownloadedContents.count > 0) count ++;
    return count;
}

static NSString *CELL_UNIQ_ID = @"UASubscriptionContentCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UASubscriptionContentCell *cell = (UASubscriptionContentCell *)[tableView
                                                                    dequeueReusableCellWithIdentifier:CELL_UNIQ_ID];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UASubscriptionContentCell"
                                                                 owner:nil
                                                               options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }


    UASubscriptionContent *content;
    if ((indexPath.section == 0) && (undownloadedContents.count > 0)) {
        content = (UASubscriptionContent *)[undownloadedContents objectAtIndex:indexPath.row];
    } else {
        content = (UASubscriptionContent *)[downloadedContents objectAtIndex:indexPath.row];
    }

    cell.content = content;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((section == 0) && (undownloadedContents.count > 0)) {
        return @"Available";
    } else
        return @"Downloaded";
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (detailViewController == nil) {
        detailViewController = [[UASubscriptionContentDetailViewController alloc]
                                initWithNibName:@"UASubscriptionContentDetailView"
                                bundle:nil];
    }
    //detailViewController.content = [contents objectAtIndex:indexPath.section];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UASubscriptionManagerObserver method

- (void)userSubscriptionsUpdated:(NSArray *)userSubscritions {
    UALOG(@"Observer notified");
    [self updateDataSource];
}

- (void)downloadContentFinished:(UASubscriptionContent *)content {
    UALOG(@"Observer notified");
    // backend data is automatically updated
    [contentsTable reloadData];
}

- (void)downloadContentFailed:(UASubscriptionContent *)content {
    UALOG(@"Observer notified");
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle: UA_SS_TR(@"UA_Error_Download")
                                                           message: UA_SS_TR(@"UA_Try_Again")
                                                          delegate: nil
                                                 cancelButtonTitle: UA_SS_TR(@"UA_OK")
                                                 otherButtonTitles: nil];
    [failureAlert show];
    [failureAlert release];
    [contentsTable reloadData];
}

@end


@implementation UASubscriptionContentCell

@synthesize title, contentDescription, icon, downloadButton, restoreButton, content;
@synthesize progressBar;

- (void)dealloc {
    RELEASE_SAFELY(content);
    RELEASE_SAFELY(title);
    RELEASE_SAFELY(contentDescription);
    RELEASE_SAFELY(icon);
    RELEASE_SAFELY(downloadButton);
    RELEASE_SAFELY(restoreButton);
    RELEASE_SAFELY(progressBar);
    [super dealloc];
}

- (void)setContent:(UASubscriptionContent *)aContent {
    [content removeObservers];

    [aContent retain];
    [content release];
    content = aContent;

    [content addObserver:self];
    [self refreshCellByContent];
}

- (void)setProgress:(id)p {
    float progress = [p floatValue];
    progressBar.progress = progress;

    if (progress >= 1) {
        progressBar.hidden = YES;
        [content removeObservers];
    }
    else {
        progressBar.hidden = NO;
    }
}

- (void)refreshCellByContent {
    self.title.text = content.contentName;
    self.contentDescription.text = content.description;
    [self.icon loadImageFromURL:content.iconURL];
    [UAViewUtils roundView:self.icon borderRadius:10.0 borderWidth:1.0 color:[UIColor darkGrayColor]];
    [downloadButton setTitle:UA_SS_TR(@"UA_Download") forState:UIControlStateNormal];
    [restoreButton setTitle:UA_SS_TR(@"UA_Restore") forState:UIControlStateNormal];
    [self setButtonState:content.downloaded];
    progressBar.hidden = !content.downloading;
}

- (void)setButtonState:(BOOL)contentIsDownloaded {
    downloadButton.hidden = contentIsDownloaded;
    restoreButton.hidden = !contentIsDownloaded;
    if (content.downloading) {
        restoreButton.enabled = !contentIsDownloaded;
        downloadButton.enabled = contentIsDownloaded;
    } else {
        downloadButton.enabled = YES;
        restoreButton.enabled = YES;
    }
}

- (IBAction)actionButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!content.downloading) {
        button.enabled = NO;
        [[UASubscriptionManager shared].inventory download:content];
    }
}

@end
