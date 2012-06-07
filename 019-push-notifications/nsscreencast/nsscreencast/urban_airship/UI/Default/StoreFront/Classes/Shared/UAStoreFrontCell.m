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

#import "UAStoreFrontCell.h"
#import "UAUtils.h"
#import "UAStoreFrontUI.h"
#import "UAAsycImageView.h"

// Weak link to this notification since it doesn't exist in iOS 3.x
UIKIT_EXTERN NSString* const UIApplicationDidEnterBackgroundNotification __attribute__((weak_import));

@implementation UAStoreFrontCell

@synthesize iconContainer;
@synthesize progressView;
@synthesize activityView;
@synthesize product;
@synthesize cellView;


- (void)dealloc {
    [product removeObserver:self];
    product = nil;
    cellView.product = nil;

    RELEASE_SAFELY(iconContainer);
    RELEASE_SAFELY(progressView);
    RELEASE_SAFELY(activityView);
    RELEASE_SAFELY(cellView);

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]))
        return nil;

    IF_IOS4_OR_GREATER(
        if (&UIApplicationDidEnterBackgroundNotification != NULL) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(enterBackground)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
                       );

    iconContainer = [[UAAsyncImageView alloc] initWithFrame:CGRectMake(11, 11, 57, 57)];
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(77, 59, 225, 9)];
    progressView.contentMode = UIViewContentModeRedraw;
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(170, 37, 20, 20)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityView.contentMode = UIViewContentModeRedraw;

    cellView = [[UAStoreFrontCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    cellView.product = self.product;
    cellView.contentMode = UIViewContentModeRedraw;
    self.contentMode = UIViewContentModeScaleToFill;

    [self.contentView addSubview:cellView];
    [self.contentView addSubview:iconContainer];
    [self.contentView addSubview:progressView];
    [self.contentView addSubview:activityView];

    return self;
}

// App is backgrounding, so unregister observers in prep for data reload later
- (void)enterBackground {
    [product removeObserver:self];
    cellView.product = nil;
    product = nil;
}

- (void)prepareForReuse { 
    product = nil; 
    cellView.product = nil;
    
    [super prepareForReuse]; 
}


- (void)setFrame:(CGRect)frame {
    if (self.frame.size.width != frame.size.width) {
        cellView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        progressView.frame = CGRectMake(77, 59, frame.size.width-18-77, 9);
        activityView.frame = CGRectMake(frame.size.width/2+10, 37, 20, 20);
    }
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if(self.selected)
        [self refreshPriceLabel:product.status];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self refreshPriceLabel:product.status];
    [cellView setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [cellView setSelected:selected];
}

#pragma mark -
#pragma mark Overrided Accessor

- (void)setProduct:(UAProduct*)newProduct {
    // StoreFront only maintains one copy of product objects in UAInventory
    if (product == newProduct)
        return;

    [product removeObserver:self];
    product = nil;
    cellView.product = nil;

    product = newProduct;
    if (product.isFree) {
        product.price = UA_SF_TR(@"UA_Free");
    }
    cellView.product = product;

    [product addObserver:self];

    [self refreshCell];
}

#pragma mark -
#pragma mark UAProduct observer

- (void)productProgressChanged:(NSNumber*)progress {
    [self refreshProgress:[progress floatValue]];
}

- (void)productStatusChanged:(NSNumber*)status {
    [self refreshCellWithProductStatus:[status intValue]];
}

#pragma mark -
#pragma mark Refresh UI

- (void)refreshCell {

    [iconContainer loadImageFromURL:product.iconURL];

    [self refreshCellWithProductStatus:product.status];
    [self refreshProgress:product.progress];
    [cellView refreshCellView];
}

- (void)refreshCellWithProductStatus:(UAProductStatus)status {
    [self refreshPriceLabel:product.status];

    switch (status) {
        case UAProductStatusUnpurchased:
        case UAProductStatusPurchased:
        case UAProductStatusInstalled:
        case UAProductStatusHasUpdate:
            progressView.hidden = YES;
            [activityView stopAnimating];
            break;
        case UAProductStatusDownloading:
            progressView.hidden = NO;
            [activityView stopAnimating];
            break;
        case UAProductStatusPurchasing:
        case UAProductStatusDecompressing:
        case UAProductStatusVerifyingReceipt:
            progressView.hidden = YES;
            [activityView startAnimating];
            break;
        default:
            break;
    }
    [cellView refreshCellViewWithProductStatus:status];
}

- (void)refreshProgress:(float)progress {
    progressView.progress = progress;
    [cellView refreshProgressView:progress];
}


- (void)refreshPriceLabel:(UAProductStatus)status {
    [cellView refreshPriceLabelView:status];
}

@end
