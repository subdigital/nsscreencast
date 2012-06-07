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

#import "UASubscriptionContentDetailViewController.h"
#import "UASubscriptionContent.h"
#import "UASubscriptionInventory.h"
#import "UAGlobal.h"
#import "UAViewUtils.h"
#import "UAAsycImageView.h"
#import "UASubscriptionManager.h"
#import "UASubscriptionUI.h"

@implementation UASubscriptionContentDetailViewController
@synthesize content;
@synthesize contentName;
@synthesize iconContainer;
@synthesize fileSize;
@synthesize revision;
@synthesize detailTable;
@synthesize previewImage;
@synthesize previewImageCell;

#pragma mark lifecyle methods

- (void)dealloc {
    RELEASE_SAFELY(fileSize);
    RELEASE_SAFELY(content);
    RELEASE_SAFELY(iconContainer);
    RELEASE_SAFELY(contentName);
    RELEASE_SAFELY(revision);
    RELEASE_SAFELY(detailTable);
    RELEASE_SAFELY(previewImage);
    RELEASE_SAFELY(previewImageCell);
    RELEASE_SAFELY(downloadButton);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    downloadButton = [[UIBarButtonItem alloc] initWithTitle:UA_SS_TR(@"UA_Download")
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(download:)];

    [UAViewUtils roundView:iconContainer borderRadius:10.0 borderWidth:1.0 color:[UIColor darkGrayColor]];
    [self refreshUI];
}

- (void)viewDidUnload {
    RELEASE_SAFELY(downloadButton);
    self.contentName = nil;
    self.iconContainer = nil;
    self.revision = nil;
    self.fileSize = nil;
    self.detailTable = nil;
    self.previewImageCell = nil;
    self.previewImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Modal/Controller Update Methods

- (void)setContent:(UASubscriptionContent *)value {
    if (value == content)
        return;

    content = value;
    [self refreshUI];
}

#pragma mark -

- (void)refreshUI {
    // empty UI when no product associated
    if (content == nil) {
        detailTable.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }

    // reset UI for product
    detailTable.hidden = NO;
    // update buy button
    if (self.navigationItem.rightBarButtonItem == nil)
        self.navigationItem.rightBarButtonItem = downloadButton;

    // table header
    contentName.text = content.contentName;
    [iconContainer loadImageFromURL:content.iconURL];

    [detailTable reloadData];
}

#pragma mark -
#pragma mark Action Methods

- (void)download:(id)sender {
    [[UASubscriptionManager shared].inventory download:content];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == 0) {
        UIFont *font = [UIFont systemFontOfSize: 16];
        NSString* text = content.description;
        CGFloat height = [text sizeWithFont: font
                          constrainedToSize: CGSizeMake(280.0, 1500.0)
                              lineBreakMode: UILineBreakModeWordWrap].height;
        return height + kCellPaddingHeight;
    } else if ([indexPath row] == 1) {
        return 320;
    }
    return 0;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (content.previewURL == nil) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    UIImage *bgImage = [UIImage imageNamed:@"middle-detail.png"];
    UIImage *stretchableBgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:stretchableBgImage];
    if (indexPath.row == 0) {
        NSString* text = content.description;
        UIFont *font = [UIFont systemFontOfSize:16];

        UILabel* description = [[UILabel alloc] init];
        description.text = text;
        description.lineBreakMode = UILineBreakModeWordWrap;
        description.numberOfLines = 0;
        description.backgroundColor = [UIColor clearColor];
        [description setFont:font];

        CGFloat height = [text sizeWithFont:font
                          constrainedToSize:CGSizeMake(280.0, 800.0)
                              lineBreakMode:UILineBreakModeWordWrap].height;
        [description setFrame:CGRectMake(0.0f, 10.0f, 320.0f, height)];
        [description setBounds:CGRectMake(0.20f, 0.0f, 290.0f, height)];
        [description setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: @"description-cell"]
                autorelease];
        [cell addSubview:description];
        [description release];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundView:bgImageView];
    } else if (indexPath.row == 1) {
        [previewImageCell setBackgroundView:bgImageView];
        [previewImage loadImageFromURL:content.previewURL];
        cell = previewImageCell;
    }
    [bgImageView release];
    return cell;
}

@end
