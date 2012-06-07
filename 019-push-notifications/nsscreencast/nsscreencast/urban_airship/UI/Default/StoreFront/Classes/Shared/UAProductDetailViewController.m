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

#import "UAUtils.h"
#import "UAViewUtils.h"
#import "UAStoreFrontUI.h"
#import "UAProductDetailViewController.h"
#import "UAAsycImageView.h"

// Weak link to this notification since it doesn't exist in iOS 3.x
UIKIT_EXTERN NSString* const UIApplicationDidEnterBackgroundNotification __attribute__((weak_import));
UIKIT_EXTERN NSString* const UIApplicationDidBecomeActiveNotification __attribute__((weak_import));

@implementation UAProductDetailViewController

@synthesize product;
@synthesize productTitle;
@synthesize iconContainer;
@synthesize price;
@synthesize fileSize;
@synthesize revision;
@synthesize detailTable;
@synthesize previewImage;
@synthesize previewImageCell;

- (void)dealloc {
    self.product = nil;
    RELEASE_SAFELY(fileSize);
    RELEASE_SAFELY(productTitle);
    RELEASE_SAFELY(iconContainer);
    RELEASE_SAFELY(price);
    RELEASE_SAFELY(revision);
    RELEASE_SAFELY(detailTable);
    RELEASE_SAFELY(previewImage);
    RELEASE_SAFELY(previewImageCell);
    RELEASE_SAFELY(buyButton);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        wasBackgrounded = NO;

        IF_IOS4_OR_GREATER(
            if (&UIApplicationDidEnterBackgroundNotification != NULL) {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(enterBackground)
                                                             name:UIApplicationDidEnterBackgroundNotification
                                                           object:nil];
            }

            if (&UIApplicationDidBecomeActiveNotification != NULL) {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(enterForeground)
                                                             name:UIApplicationDidBecomeActiveNotification
                                                           object:nil];
            }
                           );

        [self setTitle: UA_SF_TR(@"UA_Details")];
        NSString* buyString = UA_SF_TR(@"UA_Buy");

        buyButton = [[UIBarButtonItem alloc] initWithTitle:buyString
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(purchase:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UAViewUtils roundView:iconContainer borderRadius:10.0 borderWidth:1.0 color:[UIColor darkGrayColor]];
    price.textColor = kPriceFGColor;
    [UAViewUtils roundView:price borderRadius:5.0 borderWidth:1.0 color:kPriceBorderColor];
    price.backgroundColor = kPriceBGColor;

    [self refreshUI];
}

- (void)viewDidUnload {
    self.productTitle = nil;
    self.iconContainer = nil;
    self.price = nil;
    self.revision = nil;
    self.fileSize = nil;
    self.detailTable = nil;
    self.previewImage = nil;
    self.previewImageCell = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.product = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// App is backgrounding, so unregister observers in prep for data reload later
- (void)enterBackground {
    wasBackgrounded = YES;
    self.product = nil;
}

// App is returning to foreground, so get out of detail view since the reloaded
// data may no longer contain this item. This can be triggered by iOS system popups as well.
- (void)enterForeground {
    if(wasBackgrounded) {
        wasBackgrounded = NO;
        self.product = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Modal/Controller Update Methods

- (void)setProduct:(UAProduct *)value {
    if (value == product) {
        return;
    }
    
    //remove old product
    [product removeObserver:self];
    [product autorelease];
    
    //replace with new product
    product = [value retain];
    [product addObserver:self];
    
    //update UI
    [self refreshUI];
}

#pragma mark -
#pragma mark UAProductObserverProtocol

- (void)productStatusChanged:(NSNumber*)status {
    [self refreshBuyButton];
}

- (void)refreshUI {
    // empty UI when no product associated
    if (product == nil) {
        detailTable.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }

    // reset UI for product
    detailTable.hidden = NO;

    // update buy button
    if (self.navigationItem.rightBarButtonItem == nil)
        self.navigationItem.rightBarButtonItem = buyButton;

    [self refreshBuyButton];

    // table header
    productTitle.text = product.title;
    [iconContainer loadImageFromURL:product.iconURL];
    revision.text = [NSString stringWithFormat: @"%d", product.revision];
    fileSize.text = [UAUtils getReadableFileSizeFromBytes:product.fileSize];
    price.text = product.price;

    // resize price frame
    CGRect frame = price.frame;
    CGFloat frameRightBound = CGRectGetMaxX(frame);
    [price sizeToFit];
    CGRect trimmedFrame = price.frame;
    frame.size.width = trimmedFrame.size.width + 15;
    frame.origin.x = frameRightBound - frame.size.width;
    price.frame = frame;

    [detailTable reloadData];
}

- (void)refreshBuyButton {
    NSString *buttonText = nil;
    if (product.status == UAProductStatusHasUpdate) {
        buttonText = UA_SF_TR(@"UA_Update");
    } else if (product.status == UAProductStatusInstalled) {
        if ([UAStoreFrontUI shared].isiPad) {
            buttonText = UA_SF_TR(@"UA_Download"); // Let's say Download, since there are too many restore labels in iPad view
        } else {
            buttonText = UA_SF_TR(@"UA_Restore");
        }
    } else if (product.status == UAProductStatusPurchased) {
        buttonText = UA_SF_TR(@"UA_Download");
    } else if (product.status == UAProductStatusDownloading 
               || product.status == UAProductStatusPurchasing 
               || product.status == UAProductStatusVerifyingReceipt
               || product.status == UAProductStatusDecompressing) {
        buttonText = UA_SF_TR(@"UA_downloading");
    } else {
        buttonText = UA_SF_TR(@"UA_Buy");
    }
    self.navigationItem.rightBarButtonItem.title = buttonText;

    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (product.status == UAProductStatusDownloading 
        || product.status == UAProductStatusPurchasing 
        || product.status == UAProductStatusVerifyingReceipt
        || product.status == UAProductStatusDecompressing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark -
#pragma mark Action Methods

- (void)purchase:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UAStoreFront purchase:product.productIdentifier];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    if([indexPath row] == 0) {
        UIFont *font = [UIFont systemFontOfSize: 16];
        
        // calculate the size of the text
        // note: text cannot be nil as sizeWithFont
        // returns a struct init'd w/ garbage
        NSString* text = product.productDescription;
        if (text == nil) {
            text = @"";
        }
        
        CGFloat height = [text sizeWithFont: font
                          constrainedToSize: CGSizeMake(280.0, 1500.0)
                              lineBreakMode: UILineBreakModeWordWrap].height;
        return height + kCellPaddingHeight;
    } else if ([indexPath row] == 1) {
        //return 240 + kCellPaddingHeight;
        return 320;
    }
    return 0;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (product.previewURL == nil) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    UIImage *bgImage = [UIImage imageNamed:@"middle-detail.png"];
    UIImage *stretchableBgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage: stretchableBgImage];
    if (indexPath.row == 0) {
        NSString* text = product.productDescription;
        UIFont *font = [UIFont systemFontOfSize: 16];

        UILabel* description = [[UILabel alloc] init];
        description.text = text;
        description.lineBreakMode = UILineBreakModeWordWrap;
        description.numberOfLines = 0;
        description.backgroundColor = [UIColor clearColor];
        [description setFont: font];

        CGFloat height = [text sizeWithFont: font
                          constrainedToSize: CGSizeMake(280.0, 800.0)
                              lineBreakMode: UILineBreakModeWordWrap].height;
        [description setFrame: CGRectMake(0.0f, 10.0f, 320.0f, height)];
        [description setBounds: CGRectMake(0.20f, 0.0f, 290.0f, height)];
        [description setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"description-cell"] autorelease];
        [cell addSubview: description];
        [description release];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
        [cell setBackgroundView: bgImageView];
    } else if (indexPath.row == 1) {
        [previewImageCell setBackgroundView: bgImageView];
        [previewImage loadImageFromURL:product.previewURL];
        cell = previewImageCell;
    }
    [bgImageView release];
    return cell;
}

@end
