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

#import "UASubscriptionProductDetailViewController.h"
#import "UAUtils.h"
#import "UASubscriptionObserver.h"
#import "UAViewUtils.h"
#import "UAAsycImageView.h"
#import "UAGlobal.h"
#import "UASubscriptionProduct.h"
#import "UASubscriptionUI.h"
#import "UASubscriptionUIUtil.h"
#import "UASubscriptionInventory.h"

#define kAlreadyAskedUserForEmailInput @"UASubscriptionAlreadyAskedUserForEmailInput"

@implementation UASubscriptionProductDetailViewController

@synthesize productId;
@synthesize productTitle;
@synthesize iconContainer;
@synthesize price;
@synthesize detailTable;
@synthesize previewImage;
@synthesize previewImageCell;
@synthesize alertDelegate;

- (void)dealloc {
    self.productId = nil;
    [[UASubscriptionManager shared] removeObserver:self];

    RELEASE_SAFELY(productTitle);
    RELEASE_SAFELY(iconContainer);
    RELEASE_SAFELY(price);
    RELEASE_SAFELY(detailTable);
    RELEASE_SAFELY(previewImage);
    RELEASE_SAFELY(previewImageCell);
    RELEASE_SAFELY(buyButton);
    
    self.alertDelegate = nil;//assigned
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UASubscriptionManager shared] addObserver:self];

    self.alertDelegate = [UASubscriptionManager shared].transactionObserver.alertDelegate;
    
    buyButton = [[UIBarButtonItem alloc] initWithTitle:UA_SS_TR(@"UA_Buy")
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(purchase:)];

    [UAViewUtils roundView:iconContainer borderRadius:10.0 borderWidth:1.0 color:[UIColor darkGrayColor]];
    price.textColor = kPriceFGColor;
    [UAViewUtils roundView:price borderRadius:5.0 borderWidth:1.0 color:kPriceBorderColor];
    price.backgroundColor = kPriceBGColor;

    [self refreshUI];
    
    // Uncomment the following line to show an email entry form for the 
    // email-based restore process (non-autorenewables)
    // [self showUserEmailAlertOnce];
}

- (void)viewDidUnload {
    
    self.productTitle = nil;
    self.iconContainer = nil;
    self.price = nil;
    self.detailTable = nil;
    self.previewImage = nil;
    self.previewImageCell = nil;
    self.alertDelegate = nil;
    
    RELEASE_SAFELY(buyButton);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Modal/Controller Update Methods

- (void)setProduct:(UASubscriptionProduct *)product {
    if ([product.productIdentifier isEqual:self.productId]) {
        return;
    }
    
    self.productId = product.productIdentifier;
    [self refreshUI];
}

#pragma mark -

- (void)refreshUI {
    // empty UI when no product associated
    if (!productId) {
        detailTable.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    UASubscriptionProduct *product = [[UASubscriptionManager shared].inventory productForKey:productId];

    // reset UI for product
    detailTable.hidden = NO;
    // update buy button
    self.navigationItem.rightBarButtonItem = buyButton;
    buyButton.enabled = !product.isPurchasing;

    // table header    
    NSString *arDurationString;
    
    switch (product.productType) {
        case UASubscriptionProductTypeAutorenewable:
            arDurationString = [UASubscriptionUIUtil localizedAutorenewableDuration:product.autorenewableDuration];
            productTitle.text = [product.title stringByAppendingFormat:@" (%@)", arDurationString];
            break;
        case UASubscriptionProductTypeFree:
            arDurationString = UA_SS_TR(@"UA_Free_Subscription");
            productTitle.text = [product.title stringByAppendingFormat:@" (%@)", arDurationString];
            break;
        default:
            productTitle.text = product.title;
            break;
    }
    
    
    [iconContainer loadImageFromURL:product.iconURL];
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


#pragma mark -
#pragma mark Action Methods

- (void)purchase:(id)sender {
    
    [[UASubscriptionManager shared] purchaseProductWithId:productId];
    
    buyButton.enabled = NO;

}


#pragma mark -
#pragma mark Email Alert

- (BOOL)showUserEmailAlertOnce {
    
    // Only prompt for email if we don't have one and we've never prompted here before (so they only see this once)
    if ([UAUser defaultUser].email != nil || [[NSUserDefaults standardUserDefaults] boolForKey:kAlreadyAskedUserForEmailInput])
        return NO;

    if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(showAlert:for:)]) {
        [self.alertDelegate showAlert:UASubscriptionAlertShowUserEmail for:nil];
    }

    // Save this userDefault so that we only bug them once
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAlreadyAskedUserForEmailInput];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    if([indexPath row] == 0) {
        UIFont *font = [UIFont systemFontOfSize: 16];
        
        UASubscriptionProduct *product = [[UASubscriptionManager shared].inventory productForKey:productId];
        NSString* text = product.productDescription;
        
        CGFloat height = [text sizeWithFont:font
                          constrainedToSize:CGSizeMake(280.0, 1500.0)
                              lineBreakMode:UILineBreakModeWordWrap].height;
        return height + kCellPaddingHeight;
    } else if ([indexPath row] == 1) {
        return 320;
    }
    return 0;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    UASubscriptionProduct *product = [[UASubscriptionManager shared].inventory productForKey:productId];
    if (product.previewURL == nil) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UASubscriptionProduct *product = [[UASubscriptionManager shared].inventory productForKey:productId];
    
    UITableViewCell* cell = nil;
    UIImage *bgImage = [UIImage imageNamed:@"middle-detail.png"];
    UIImage *stretchableBgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:stretchableBgImage];
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

#pragma mark UASubscriptionManager Callbacks

- (void)purchaseProductFinished:(UASubscriptionProduct *)aProduct {
    if ([productId isEqual:aProduct.productIdentifier]) {
        buyButton.enabled = YES;
    }
}

- (void)purchaseProductFailed:(UASubscriptionProduct *)failedProduct withError:(NSError *)error {
    if ([productId isEqual:failedProduct.productIdentifier]) {
        buyButton.enabled = YES;
    }
}

#pragma mark UAUserObserver

//- (void)userRecoveryFinished {
//
//    if(purchaseProduct.productIdentifier == pid) {
//
//        // This transaction should not begin in every case - only if the user is ACTUALLY buying something. This notified can be invoked in another case, where the
//        // user is simply recovering their account, not associated with any purchase. Or the user may not be on this page anymore when the callback is invoked.
//
//        [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProductIdentifier:purchaseProduct.productIdentifier]];
//        purchaseProduct = nil;
//    }
//}
//
//- (void)userRecoveryCancelled {
//
//    if(purchaseProduct.productIdentifier == pid) {
//
//        // This transaction should not begin in every case - only if the user is ACTUALLY buying something. This notified can be invoked in another case, where the
//        // user is simply recovering their account, not associated with any purchase. Or the user may not be on this page anymore when the callback is invoked.
//
//        [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProductIdentifier:purchaseProduct.productIdentifier]];
//        purchaseProduct = nil;
//    }
//}

@end
